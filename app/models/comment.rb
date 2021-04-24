# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  validates :user_id, presence: true
  validates :tour_id, presence: true
  

end
