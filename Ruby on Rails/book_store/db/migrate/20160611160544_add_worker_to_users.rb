class AddWorkerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :worker, :boolean
  end
end
