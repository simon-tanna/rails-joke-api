class UsersController < ApplicationController

    def create
        @user = User.create(user_params)
        if @user.save
            auth_token = Knock::AuthToken.new payload: {subject: @user.id}
            render json: {username: @user.username, jwt: auth_token.token}, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def sign_in
        @user = User.find_by_email(user_params[:email])
        if @user && @user.authenticate(user_params[:password])
            auth_token = Knock::AuthToken.new payload: {subject: @user.id}
            render json: {username: @user.username, jwt: auth_token.token}, status: 200
        else
            render json: {error: "Incorrect username or password"}, status: 404
        end
    end

    private
    def user_params
        params.permit(:username, :email, :password, :password_confirmation)
    end
end
