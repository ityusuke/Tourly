# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tours, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tours, through: :likes, source: :tour
  has_many :favorites, dependent: :destroy
  has_many :favtours, through: :favorites, source: :tour

  devise:omniauthable,:rememberable
  
  validates :username, presence: true, length: { maximum: 25, minimum: 4 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { maximum: 15, minimum: 4 },
                      confirmation: true, exclusion: { in: %w($ # % & ' ( ) ' =) }
  validates :comment, length: { maximum: 255}
  mount_uploader :user_image, UserImageUploader

  def remember_me
    true
  end

  def faved?(tour)
    puts "fav?"
    puts tour.id
    favtours.include?(tour)
  end

  def self.find_for_google_oauth2(auth)
    user = User.where(email: auth.info.email).first
    user ||= User.create(name: auth.info.name,
                        provider: auth.provider,
                        uid: auth.uid,
                        email: auth.info.email,
                        token: auth.credentials.token,
                        password: Devise.friendly_token[0, 20])
    user
  end


end
