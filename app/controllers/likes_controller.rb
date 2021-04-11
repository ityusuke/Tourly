# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :check_user_login?, only: %i[create destroy]
  
  def create
    @tour = Tour.find_by(id: params[:tour_id])
    @like = Like.create(user_id: current_user.id, tour_id: @tour.id)
    puts "this is like"
    @likes = Like.where(tour_id: @tour.id)
    @comments = Comment.where(tour_id: @tour.id)
    # redirect_back(fallback_location: root_path)
    # render 'create.js.erb'
  end
  
  def destroy
    @tour = Tour.find_by(id: params[:tour_id])
    @like = current_user.likes.find_by(tour_id: params[:tour_id])
    @like.destroy
    @likes = Like.where(tour_id: @tour.id)
    @comments = Comment.where(tour_id: @tour.id)
    # render 'destroy.js.erb'
    # redirect_back(fallback_location: root_path)
  end
end
