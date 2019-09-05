# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!


  def create
    user = User.find(params[:relationship][:follow_id])
    following = current_user.follow(user)
    if following.save!
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
      redirect_to user
    else
      flash.now[:alert] = 'ユーザーのフォローに失敗しました'
      redirect_to user
    end
  end

  def destroy
    user = User.find(params[:relationship][:follow_id])
    following = current_user.unfollow(user)
    if following.destroy
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
      redirect_to user
    else
      flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました'
      redirect_to user
    end
  end
end
