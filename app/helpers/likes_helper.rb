# frozen_string_literal: true

module LikesHelper
  def liked?(tour)
    puts "this is helper"
    puts tour
    puts tour.id
    Like.find_by(user_id: current_user.id, tour_id: tour.id)
  end
end
