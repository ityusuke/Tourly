class SpotsController < ApplicationController

  def map
    @spots = Spot.all.where.not(spotname: [nil, '']).where.not(x: [nil, '']).where.not(y: [nil, '']).to_json
  end

  def show
    @spot = Spot.find_by(id: params[:id])
    render json: @spot
  end
end
