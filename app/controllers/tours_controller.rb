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
    # @like.id = @tour.id
    @likes = Like.where(tour_id: @tour.id)
    @comment = Comment.new
    @favorite = Favorite.new
    @comments = Comment.where(tour_id: @tour.id)
    @spot0 = @tour.spots[0]
    @spot1 = @tour.spots[1]
  end

  def new
    @tour = Tour.new
    @spots = @tour.spots.build 
  end

  def create
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
    params.require(:tour).permit(:tourname, :tourcontent,:tour_type,:season,
                                  :q,spots_attributes: [:id,:spotname,:spotcontent,:images,:tour_id])
  end

  def tour_find_by_id
    @tour = Tour.find_by(id: params[:id])
    @spots = @tour.spots
  end
  

end
