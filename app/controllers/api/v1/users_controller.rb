class Api::V1::UsersController < ApplicationController
	respond_to :json
  skip_before_action  :verify_authenticity_token

  def create
  	if !params[:user].nil? && params[:user].present?
	  	user = User.new(user_params)
	  	if user.save
	  		render json: { :message => "User has been created!", :user => user }, :status => 200
	  	else
	  		render json: { :message => "There was an error in creating user. Please try again.", :errors => user.errors }, :status => 200
	  	end
	  else
	  	render json: { :message => "Bad request!" }, :status => 400
	  end
  end

  def login
  	user = User.where( :email => params[:email]).first
	  if user && user.valid_password?(params[:password])
	    token = Tiddle.create_and_return_token(user, request)
    	render json: { authentication_token: token }, :status => 200
	  else
	    render json: { :message => "Invalid Credentials!!!"}, :status => 200
	  end
  end

  private

  	def user_params
  		params.require(:user).permit(:email, :name, :password, :password_confirmation)
  	end

end