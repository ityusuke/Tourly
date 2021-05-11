# frozen_string_literal: true

class ToursController < ApplicationController
  before_action :check_user_login?, only: %i[show new create edit update destroy]
  before_action :set_search

  def index    
    if params[:tag]
      @tours= Tour.ransack(tour_tags_cont: params[:tag]).result.page(params[:page])
    elsif params[:q]
      @q = Tour.includes(:user).ransack(params[:q])
      @tours= @q.result(distinct: :true).page(params[:page])
    else
      @tours = Tour.includes(:user).page(params[:page])
    end
    @tags = get_all_tags
  end

  def map
    @spots = Spot.all.where.not(spotname: [nil, '']).where.not(x: [nil, '']).where.not(y: [nil, '']).to_json
  end

  def show
    @tour = Tour.find_by(id: params[:id])
    @like = Like.find_by(user_id: current_user.id)
    @favorite = Favorite.find_by(user_id: current_user.id)
    @comment = Comment.new
    @comments = @tour.comments
  end


  def new
    @tour = Tour.new
    @spots = @tour.spots.build 
    @tour_type = TOUR_TYPE_ARRAY
  end

  def create
    @tour = current_user.tours.new(tour_params)
    if @tour.save
      redirect_to user_path(id: current_user.id), notice: FLASH_TOUR_NEW_SUCCESS
    else
      flash.now[:alert] = FLASH_TOUR_NEW_FAILED
      @tour = Tour.new(tour_params);
      render new_tour_path
    end
  end

  def edit
    @tour = Tour.find_by(id: params[:id])
  end

  def update
    @tour = Tour.find_by(id: params[:id])
    if @tour.update(tour_params)
      redirect_to tour_path(id: @tour.id), notice: FLASH_TOUR_EDIT_SUCCESS
    else
      flash.now[:alert] = FLASH_TOUR_EDIT_FAILED
      render edit_tour_path
    end
  end

  def destroy
    @tour = Tour.find_by(id: params[:id])
    @tour.destroy
    redirect_to user_path(id: current_user.id), notice: FLASH_TOUR_DELETE_SUCCESS
  end

  private

  def get_all_tags
    tags = []
    Tour.all.map {|tour|  
      if !tour.tour_tags.nil?
        tour.tour_tags.split(SPLIT_WITH_COMMA).map {|tag|  
          tags.push(tag)
        }
      end
    } 
    return tags.uniq
  end

  # def get_spots_hash
  #   spots_data = nil
  #   Spot.all.map {|spot|  
  #     if !spot.x.present? && !spot.y.present? && !spot.spotname.present? && !spot.tour_id.present?
  #       spots_data += 
  #     end
  #   } 
  #   return tags.uniq
  # end

  def tour_params
    params.require(:tour).permit(:tourname, :tourcontent,:tour_type,:season,:tour_tags,
                                  :q,spots_attributes: [:id,:spotname,:spotcontent,:x,:y,:evaluate,:price,:time,:spot_images,:tour_id, :_destroy])
  end
  

end
