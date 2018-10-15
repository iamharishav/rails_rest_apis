class Api::V1::CategoriesController < ApplicationController
	
	respond_to :json
	before_action :authenticate_user!
	skip_before_action  :verify_authenticity_token

	def index
		categories = Category.all.select(:id, :name).order(:id => "DESC")
		render json: { :categories => categories.as_json(
											:include => { :articles => {:only => [:id,:title,:post_body]} }
										)

								 }, :status => 200
	end

	def create
		category = Category.new(category_params)
		if category.save
			render json: { :message => "Category has been created!" }, :status => 200
		else
			render json: { :message => "There was an error in creating category. Please try again.", :errors => category.errors }, :status => 201
		end
	end

	def update
		if category = Category.where(:id => params[:id]).first
			if category.update(category_params)
				render json: { :message => "Category was updated successfully." }, :status => 200
			else
				render json: { :message => "There was a problem in updating category. Please try again"}
			end
		else
			render json: { :message => "There was a problem in updating category. Please try again"}
		end
	end

	private

		def category_params
			params.require(:category).permit(:name)
		end

end