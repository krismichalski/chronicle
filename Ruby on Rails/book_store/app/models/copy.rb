class Copy < ActiveRecord::Base
  belongs_to :book
  has_many :borrows, dependent: :destroy

  attr_accessor :user_id

  before_create :initial_state

  state_machine :state do
    after_transition :free => :borrowed, do: :create_borrow
    after_transition :free => :reserved, do: :create_reservation
    after_transition :reserved => :borrowed, do: :reservation_done
    after_transition :reserved => :free, do: :reservation_cancel
    after_transition :borrowed => :free, do: :borrow_done

    event :borrow do
      transition [:free, :reserved] => :borrowed
    end
    event :reserve do
      transition [:free, :borrowed] => :reserved
    end
    event :return do
      transition :borrowed => :free
    end
    event :cancel do
      transition :reserved => :free
    end
    event :report do
      transition :borrowed => :repair_needed
    end
    event :send_to_repair do
      transition :repair_needed => :in_repair
    end
    event :discard do
      transition [:repair_needed, :in_repair] => :discarded
    end
  end

  def prolongate
    borrows.where(user_id: user_id).last.update(return_planned_at: 7.days.from_now)
  end

  private

  def initial_state
    self.state = 'free'
  end

  def create_borrow
    borrows.create(user_id: user_id, borrowed_at: Time.now, return_planned_at: 7.days.from_now, reservation: false)
  end

  def create_reservation
    borrow = create_borrow
    borrow.update(reservation: true)
  end

  def reservation_done
    borrows.last.update(borrowed_at: Time.now, return_planned_at: 7.days.from_now, reservation: false)
  end

  def reservation_cancel
    borrows.last.destroy
  end

  def borrow_done
    borrows.where(returned_at: nil, reservation: false).last.update(returned_at: Time.now)
  end

end
