# frozen_string_literal: true

class CommentsController < ApplicationController
before_action :check_user_login?, only: %i[create destroy]

def count
  @tour = Tour.find_by(id: params[:tour_id])
  puts @tour.comments.count
  render json: @tour.comments.count
end

def create
  @tour = Tour.find_by(id: params[:tour_id])
  @comment = current_user.comments.new(comment_params)
  @comment.tour_id = params[:tour_id]
  puts "controller"
  puts params
  if @comment.save
  flash.now[:notice] = 'コメントしました'
  @comments = Comment.where(tour_id: @comment.tour_id)
  render "create.js.erb"
  # redirect_back(fallback_location: root_path)
  else
  flash.now[:notice] = 'コメントに失敗しました'
  @comments = Comment.where(tour_id: @comment.tour_id)
  render "create.js.erb"
  # redirect_back(fallback_location: root_path)
  end
end

def destroy
  @tour = Tour.find_by(id: params[:tour_id])
  @comment = current_user.comments.find_by(tour_id: params[:tour_id])
  @comment.destroy!
  @comments = Comment.where(tour_id: @comment.tour_id)
# redirect_back(fallback_location: root_path)
render "destory.js.erb"
end

private

def comment_params
params.require(:comment).permit(:title,:evaluate,:content, :tour_id, :user_id)
end
end
