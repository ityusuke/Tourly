# frozen_string_literal: true

class Tour < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :favorites, foreign_key: 'tour_id', dependent: :destroy
  has_many :users, through: :favorites, dependent: :destroy
  has_many :spots, dependent: :destroy,inverse_of: :tour

  accepts_nested_attributes_for :spots
  validates :user_id, presence: true
  validates :tourcontent, presence: true, length: { maximum: 325 }


   

  
  def self.search(search)
    return Tour.all unless search

    Tour.where(['tourcontent LIKE ?', "%#{search}%"])
  end
end
