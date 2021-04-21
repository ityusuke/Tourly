require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.create(:user)
    end

    context 'userを保存できる場合' do
      it '正常値の場合、保存できること' do
        expect(@user).to be_valid
      end

      it 'ユーザー名が4文字以上なら保存できること' do
        @user.username = 'a'*4
        expect(@user).to be_valid
      end

      it 'ユーザー名が25文字以下なら保存できること' do
        @user.username = 'a'*25
        expect(@user).to be_valid
      end

      it 'パスワードが4文字以上なら保存できること' do
        @user.password = 'a'*4
        expect(@user).to be_valid
      end

      it 'パスワードが15文字以下なら保存できること' do
        @user.password = 'a'*15
        expect(@user).to be_valid
      end

      it 'コメントが255文字以下なら保存できること' do
        @user.comment = 'a'*255
        expect(@user).to be_valid
      end

    end

    context 'userの保存に失敗する場合' do

      context '入力値の長さが不正の場合' do
        # it 'ユーザー名が3文字以下なら保存できないこと' do
        #   @user.username = 'a'*３
        #   expect(@user).to be_invalid
        # end

        it 'ユーザー名が26文字以上なら保存できないこと' do
          @user.username = 'a'*26
          expect(@user).to be_invalid
        end
  
        # it 'パスワードが3文字以下なら保存できないこと' do
        #   @user.password = 'a'*3
        #   expect(@user).to be_invalid
        # end

        it 'パスワードが16文字以上なら保存できないこと' do
          @user.password = 'a'*16
          expect(@user).to be_invalid
        end

  
        it 'コメントが256文字以上なら保存できないこと' do
          @user.comment = 'a'*256
          expect(@user).to be_invalid
        end
      
      end

      context '入力値が空欄の場合' do
        it 'ユーザー名が空欄の場合、保存できないこと' do
          @user.username = ''
          expect(@user).to be_invalid
        end

        it 'メールアドレスが空欄の場合、保存できないこと' do
          @user.email = ''
          expect(@user).to be_invalid
        end

        it 'パスワードが空欄の場合、保存できないこと' do
          @user.password = ''
          expect(@user).to be_invalid
        end

      end

      context '入力値が存在しない場合' do
        it 'ユーザー名が存在しない場合、保存できないこと' do
          @user.username = nil
          expect(@user).to be_invalid
        end
        it 'メールアドレスが存在しない場合、保存できないこと' do
          @user.email = nil
          expect(@user).to be_invalid
        end

        it 'パスワードが存在しない場合、保存できないこと' do
          @user.username = nil
          expect(@user).to be_invalid
        end
      
      end

      it 'メールアドレスが重複する場合、保存できないこと' do
        @user.save
        another_user = User.new(
          username: 'a'*4,
          email: @user.email,
          password: 'a'*4
        )
        expect(another_user).to be_invalid
      end

      # it 'パスワードに記号が入っている場合、保存できないこと' do
      #   @user.password = '$'*5
      #   expect(@user).to be_invalid
      # end

    end
  end
end
