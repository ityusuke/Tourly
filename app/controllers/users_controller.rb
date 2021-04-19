# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :check_user_login?, only: [:show]

  def new
  @user=User.new
  end
  
  def create
    @user=User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_path
    else
      render new_user_path
    end
  end


  def edit
  user_find_by_id
  end

  def update
    user_find_by_id
      if @user.update(user_params)
      @user.username = params[:username]
        log_in @user
      redirect_to @user
      else
      render edit_user_path
      end
  end

  def destroy
    user_find_by_id
    @user.destroy
  end

  def show
    user_find_by_id
    @tours = Tour.where(user_id: @user.id)
    @favorites = Favorite.where(user_id: @user.id)
  end

  def followings
    user_find_by_id
    @users = @user.followings.page(params[:page])
    render 'follow'
  end

  def followers
    user_find_by_id
    @users = @user.followers.page(params[:page])
    render 'follow'
  end

  def favorite
    @tours = current_user.favtours.page(params[:page])
  end

  private

  def user_find_by_id
    @user = User.find_by(id: params[:id])
  end
  def user_params
    params.require(:user).permit(:username,:email, :password,:user_image,:comment)
  end
  
end
