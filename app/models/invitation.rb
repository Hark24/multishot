class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  PENDING_EVENT = 0
  ACCEPTED_EVENT = 1
  REJECT_EVENT = 2

  def self.numPending user_id
    self.where(:state => PENDING_EVENT, :user_id => user_id).size
  end
end
