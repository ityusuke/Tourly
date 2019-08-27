# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'username' }
    email { 'email@google.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
