Rails.application.routes.draw do
  get 'messages/index'
  devise_for :users
  root to: "rooms#index"
  resources :users, only: [:edit, :update]
  resources :rooms, only: [:new, :create,:destroy] do
    resources :messages, only: [:index, :create] # roomsの中にmessagesを配置し、商品投稿ルームに属しているメッセージというネスト設定
  end
end
