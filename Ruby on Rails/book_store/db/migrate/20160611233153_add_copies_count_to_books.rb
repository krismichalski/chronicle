class AddCopiesCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :copies_count, :integer
  end
end
