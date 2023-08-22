class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :prefecture, :string
    add_column :users, :due_date, :date
  end
end
