class AddDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :pesel, :string
    add_column :users, :address, :string
  end
end
