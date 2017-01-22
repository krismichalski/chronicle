class Borrow < ActiveRecord::Base
  belongs_to :user
  belongs_to :copy
  has_many :penalties, dependent: :destroy
end
