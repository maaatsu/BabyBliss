# テーブル設計

##  items テーブル

| Column             | Type    | Options                        |
| ------------------ | ------- | ------------------------------ |
| title              | string  | null: false                    |
| description        | text    | null: false                    |
| price              | integer | null: false                    |
| user_id            | string  | null: false, foreign_key: true |

### Association

* belongs_to :user
* has_many :favorites
* has_many :comments
* has_many :item_images
* has_many :reviews
* has_many :item_tags
* has_many :tags, through: :item_tags

## users テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| name               | string | null: false               |
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |

### Association

* has_many :items
* has_many :favorites
* has_many :comments
* has_many :reviews
* has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
* has_many :followed_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
* has_many :followings, through: :follower_relationships, source: :followed
* has_many :followers, through: :followed_relationships, source: :follower

## favorites テーブル

| Column             | Type   | Options                        |
| ------------------ | ------ | ------------------------------ |
| user_id            | bigint | null: false, foreign_key: true |
| item_id            | bigint | null: false, foreign_key: true |

### Association

* belongs_to :user
* belongs_to :item

## comments テーブル

| Column             | Type   | Options                        |
| ------------------ | ------ | ------------------------------ |
| user_id            | bigint | null: false, foreign_key: true |
| item_id            | bigint | null: false, foreign_key: true |
| content            | text   | null: false                    |

### Association

* belongs_to :user
* belongs_to :item

## relationships テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| follower_id        | bigint | null: false               |
| followed_id        | bigint | null: false, unique: true |

### Association

* belongs_to :follower, class_name: 'User'
* belongs_to :followed, class_name: 'User'

## categories テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| name               | string | null: false               |

### Association

* has_many :items

## item_images テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| item_id            | bigint | null: false               |
| imege_url          | string | null: false, unique: true |

### Association

* belongs_to :item

## reviews テーブル

| Column             | Type    | Options                   |
| ------------------ | ------- | ------------------------- |
| user_id            | bigint  | null: false               |
| item_id            | bigint  | null: false, unique: true |
| rating             | integer | null: false               |
| comment            | text    | null: false               |

### Association

* belongs_to :user
* belongs_to :item

## tags テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| name               | string | null: false               |

### Association

* has_many :item_tags
* has_many :items, through: :item_tags

## item_tags テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| item_id            | bigint | null: false               |
| tag_id             | bigint | null: false, unique: true |

### Association

* belongs_to :item
* belongs_to :tag