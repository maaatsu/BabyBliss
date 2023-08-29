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
      it 'ニックネームが空では登録できない' do
        @user.nickname = '' # 空のニックネーム設定
        @user.valid?
        expect(@user.errors[:nickname]).to include("を入力してください")
      end

      it 'メールアドレスが空では登録できない' do
        @user.email = '' # 空のメールアドレス設定
        @user.valid?
        expect(@user.errors[:email]).to include("を入力してください")
      end

      it '重複したメールアドレスが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.save
        if another_user.errors.has_key?(:email)
          expect(another_user.errors[:email]).to include('メールアドレスはすでに存在します')
        end
      end

      it 'メールアドレスは@を含まないと登録できない' do
        @user.email = 'testmail' # @を含まないメールアドレス設定
        @user.valid?
        expect(@user.errors[:email]).to include('メールアドレスは無効です')
      end

      it 'パスワードが空では登録できない' do
        @user.password = '' # 空のパスワード設定
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors[:password]).to include("を入力してください")
      end

      it 'パスワードが5文字以下では登録できない' do
        @user.password = '00000' # 5桁のパスワード設定
        @user.password_confirmation = '00000' # 5桁のパスワード再入力設定
        @user.valid?
        expect(@user.errors[:password]).to include('は6文字以上で入力してください')
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

      it 'パスワードとパスワード再入力が不一致では登録できない' do
        @user.password = '123456' # 6桁のパスワード設定
        @user.password_confirmation = '1234567' # 7桁のパスワード設定
        @user.valid?
        expect(@user.errors[:password_confirmation]).to include("が一致しません")
      end

    end
  end
end
