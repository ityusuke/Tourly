# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tour, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.create(:user) do |s| 
        s.tours.create(
          tourname: 'MyString',
          tourcontent: 'MyText'
        ) 
      end
      @tour = @user.tours[0]
    end

    context 'ツアーを保存できる場合' do
      it '正常値の場合、保存できること' do
        expect(@tour).to be_valid
      end

      it 'ツアー名が30文字以内の場合、保存できること' do
        @tour.tourname = "a"*30
        expect(@tour).to be_valid
      end

    end
    context 'ツアーを保存できない場合' do

      it 'ツアー名が31文字以上の場合、保存できないこと' do
        @tour.tourname = "a"*31
        expect(@tour).to be_invalid
      end

      it 'ツアー名が空白の場合、保存できないこと' do
        @tour.tourname = ""
        expect(@tour).to be_invalid
      end

      it 'ツアー名が存在しない場合、保存できないこと' do
        @tour.tourname = nil
        expect(@tour).to be_invalid
      end

    end
  end
end
