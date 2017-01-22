class CreateBorrows < ActiveRecord::Migration
  def change
    create_table :borrows do |t|
      t.references :user, index: true, foreign_key: true
      t.references :copy, index: true, foreign_key: true
      t.datetime :borrowed_at
      t.datetime :return_planned_at
      t.datetime :returned_at
      t.boolean :reservation

      t.timestamps null: false
    end
  end
end
