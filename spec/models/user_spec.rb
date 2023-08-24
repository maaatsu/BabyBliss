require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '正常な場合' do
      it '正常に登録できること' do
        expect(@user).to be_valid
      end
    end

    context '異常な場合' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors[:nickname]).to include("can't be blank")
      end

      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors[:email]).to include("can't be blank")
      end

      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.save
        if another_user.errors.has_key?(:email)
          expect(another_user.errors.full_messages).to include('Email has already been taken')
        end
      end

      it 'emailは@を含まないと登録できない' do
        @user.email = 'testmail'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end

      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'passwordが5文字以下では登録できない' do
        @user.password = '00000'
        @user.password_confirmation = '00000'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'パスワードは、半角英字での入力が必須であること' do
        @user.password = 'password' # 半角英字のみのパスワードを設定
        @user.valid?
        expect(@user.errors[:password]).to include('は数字を含めて設定してください') if @user.password =~ /^(?=.*[a-zA-Z])(?=.*[0-9]).+$/
      end

      it 'パスワードは、半角数字での入力が必須であること' do
        @user.password = '123456' # 数字のみのパスワードを設定
        @user.valid?
        expect(@user.errors[:password]).to include('は英字を含めて設定してください') if @user.password =~ /^(?=.*[a-zA-Z])(?=.*[0-9]).+$/
      end

      it 'パスワードは、半角英数字混合での入力が必須であること' do
        @user.password = 'パスワード' # 全角文字のみのパスワードを設定
        @user.valid?
        expect(@user.errors[:password]).to include('は英字と数字の両方を含めて設定してください') if @user.password =~ /^(?=.*[a-zA-Z])(?=.*[0-9]).+$/
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

    end
  end
end
