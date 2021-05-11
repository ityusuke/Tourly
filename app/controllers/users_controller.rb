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
      redirect_to root_path, notice: FLASH_USER_NEW_SUCCESS
    else
      flash.now[:alert] = FLASH_USER_NEW_FAILED
      redirect_to new_user_path
    end
  end


  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
      if @user.update(user_params)
        @user.username = params[:username]
        log_in @user
        redirect_to @user, notice: FLASH_USER_EDIT_SUCCESS
      else
        flash.now[:alert] = FLASH_USER_EDIT_FAILED
        redirect_to  edit_user_path(@user.id)
      end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    redirect_to root_path, notice: FLASH_USER_DELETE_SUCCESS
  end

  def show
    @user = User.find_by(id: params[:id])
    @tours = Tour.where(user_id: @user.id)
    @like_tours = Tour.includes(:likes).references(:likes).where("likes.user_id = ?", @user.id)
    @favorite_tours = Tour.includes(:favorites).references(:favorites).where("favorites.user_id = ?", @user.id)
    @favorites = Favorite.where(user_id: @user.id)
  end

  private

  def user_params
    params.require(:user).permit(:username,:email, :password,:user_image,:comment)
  end
  
end
