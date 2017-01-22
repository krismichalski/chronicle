class Penalty < ActiveRecord::Base
  belongs_to :borrow
  has_one :user, through: :borrow
end
