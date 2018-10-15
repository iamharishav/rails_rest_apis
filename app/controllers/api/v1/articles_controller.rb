class Api::V1::ArticlesController < ApplicationController
	respond_to :json
	before_action :authenticate_user!
	skip_before_action :verify_authenticity_token
	
	def index
		articles = Article.includes(:category, :user).where( :user_id => current_user ).all.order(:id => "DESC")
		render json:  { :articles => articles.as_json( :only => [:id, :title, :post_body ], 
																									 :include => { 
																																:category => { :only => [:name] }, 
																																:user => { :only => [:name] } }
																								  ) 
									}, :status => 200
	end

	def create
		article = Article.new(article_params)
		article.user_id = current_user.id
		if article.save
			render json: { :message => "Article has been saved successfully.", :article => article }, :status => 200
		else
			render json: { :message => "There was an error in saving the article. Please try again.", :errors => article.errors }, :status => 202
		end
	end

	def update
		if article = set_article
			if article.update(article_params)
				render json: { :message => " Article was updated successfully." }, :status => 200
			else
				render json: { :message => "There was an error in updating article. Please try again." }, :status => 200
			end
		else
			render json: { :message => "You are not authorised to update the article." }, :status => 200
		end
	end

	def show
		if article = set_article
			render json: { :article => article.as_json( :only => [:id, :title, :post_body ], 
																									 :include => { 
																																:category => { :only => [:name] }, 
																																:user => { :only => [:name] } }
																								  ) 
									}, :status => 200
		else
			render json: { :message => " You are not authorised to view the article"}
		end
	end

	def destroy
		if article = set_article
			if article.destroy
				render json: { :message => " Article was deleted successfully." }, :status => 200
			else
				render json: { :message => "There was an error in deleting article. Please try again." }, :status => 200
			end
		else
			render json: { :message => "You are not authorised to delete the article." }, :status => 200
		end
	end

	private
		def set_article
			article = Article.where(:id => params[:id]).where(:user_id => current_user.id ).first
		end

		def article_params
			params.require(:article).permit(:title, :category_id, :post_body)
		end

end