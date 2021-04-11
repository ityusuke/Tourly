# frozen_string_literal: true

class ToursController < ApplicationController
  before_action :check_user_login?, only: %i[show new create edit update destroy]
  before_action :set_search
  def index

  if params[:q]
    @q = Tour.includes(:user).ransack(params[:q])
    @tours= @q.result(distinct: :true).page(params[:page])
  else
    @tours = Tour.includes(:user).page(params[:page])
  end
  end

  def show
    tour_find_by_id
    @like = Like.new
    @likes = Like.where(tour_id: @tour.id)
    @comment = Comment.new
    @comments = Comment.where(tour_id: @tour.id)
    puts @tour.tour_tags.split(",")
    @favorite = Favorite.new
  end

  def new
    @tour = Tour.new
    @spots = @tour.spots.build 
    @tour_type = [{ "1": "一人で"}, { "2": "友達と" }, { "3": "恋人と" }, { "4": "家族と" }]
  end

  def create
    puts params
    if @tour = current_user.tours.new(tour_params).save
    
      redirect_to user_path(id: current_user.id)
    else
      render new_tour_path
    end
  end

  def edit
    tour_find_by_id
  end

  def update
    tour_find_by_id
    if @tour.update(tour_params)
      redirect_to tour_path(id: @tour.id)
    else
      render edit_tour_path
    end
  end

  def destroy
    tour_find_by_id
    @tour.destroy
    redirect_to user_path(id: current_user.id)
  end

  private

  def tour_params
    params.require(:tour).permit(:tourname, :tourcontent,:tour_type,:season,:tour_tags,
                                  :q,spots_attributes: [:id,:spotname,:spotcontent,:x,:y,:evaluate,:price,:time,:spot_images,:tour_id])
  end

  def tour_find_by_id
    @tour = Tour.find_by(id: params[:id])
    @spots = @tour.spots
  end
  

end
