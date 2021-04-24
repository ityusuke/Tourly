# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tours, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tours, through: :likes, source: :tour
  has_many :favorites, dependent: :destroy
  has_many :favtours, through: :favorites, source: :tour
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

    devise:omniauthable,:rememberable
  # devise :database_authenticatable, 
  #        :recoverable, :rememberable, 
  #       :registerable,:omniauthable
  #       # ,:validatable
  
  validates :username, presence: true, length: { maximum: 25 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { maximum: 15, minimum: 4 },
                      confirmation: true, exclusion: { in: %w($ # % & ' ( ) ' =) }
  mount_uploader :user_image, UserImageUploader

  def remember_me
    true
  end

  def faved?(tour)
    puts "fav?"
    puts tour.id
    favtours.include?(tour)
  end

  def follow(other_user)
    unless self == other_user
      relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship&.destroy
  end

  def following?(other_user)
    followings.include?(other_user)
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
