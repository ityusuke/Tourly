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

  def show
    @tour = Tour.find_by(id: params[:id])
    @like = Like.new
    @comment = Comment.new
    @favorite = Favorite.new
    @comments = @tour.comments
  end

  def new
    @tour = Tour.new
    @spots = @tour.spots.build 
    @tour_type = [{ "1": "一人で"}, { "2": "友達と" }, { "3": "恋人と" }, { "4": "家族と" }]
  end

  def create
    puts params
    if @tour = current_user.tours.new(tour_params).save
      redirect_to user_path(id: current_user.id), notice: 'ツアーを登録しました'
    else
      flash.now[:alert] = 'ツアーの登録に失敗しました'
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
      redirect_to tour_path(id: @tour.id), notice: 'ツアーを更新しました'
    else
      flash.now[:alert] = 'ツアーの更新に失敗しました'
      render edit_tour_path
    end
  end

  def destroy
    @tour = Tour.find_by(id: params[:id])
    @tour.destroy
    redirect_to user_path(id: current_user.id), notice: 'ツアーを削除しました'
  end

  private

  def get_all_tags
    tags = []
    Tour.all.map {|tour|  
      if !tour.tour_tags.nil?
        tour.tour_tags.split(",").map {|tag|  
          tags.push(tag)
        }
      end
    } 
    return tags.uniq
  end

  def tour_params
    params.require(:tour).permit(:tourname, :tourcontent,:tour_type,:season,:tour_tags,
                                  :q,spots_attributes: [:id,:spotname,:spotcontent,:x,:y,:evaluate,:price,:time,:spot_images,:tour_id, :_destroy])
  end
  

end
