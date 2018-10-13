class UsersController < ApplicationController
  def show
    params.permit(:sort_order)
    @user = User.find(params[:id])
    @reviews = @user.sorted_reviews(params[:sort_order])
  end
end
