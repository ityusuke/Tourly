# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    @tour = Tour.find_by(id: params[:tour_id])
    if @favorite = Favorite.create(user_id: current_user.id, tour_id: params[:tour_id])
      flash.now[:notice] = 'お気に入りしました'
      puts "controller"
      puts @favorite.id
    else
      flash.now[:notice] = 'お気に入りできませんでした'
 
    end
  end

  def destroy
    @like =Like.new
    @tour = Tour.find(params[:id])
    @favorite = current_user.favorites.find_by(tour_id: params[:tour_id])
    @favorite.destroy
    flash.now[:notice] = 'お気に入りしました'
 
  end
end
