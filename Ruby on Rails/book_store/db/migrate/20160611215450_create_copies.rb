class CreateCopies < ActiveRecord::Migration
  def change
    create_table :copies do |t|
      t.references :book, index: true, foreign_key: true
      t.string :state

      t.timestamps null: false
    end
  end
end
