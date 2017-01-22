class AddPaidAtToPenalties < ActiveRecord::Migration
  def change
    add_column :penalties, :paid_at, :datetime
  end
end
