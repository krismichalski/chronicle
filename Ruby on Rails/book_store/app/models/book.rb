class Book < ActiveRecord::Base
  has_many :copies, dependent: :destroy
  after_create :create_copies

  private

  def create_copies
    current_copies_count = copies.count
    (copies_count - current_copies_count).times do
      copies.create
    end
  end
end
