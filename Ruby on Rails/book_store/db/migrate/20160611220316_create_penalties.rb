class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.references :borrow, index: true, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.boolean :paid

      t.timestamps null: false
    end
  end
end
