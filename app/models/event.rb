class Event < ActiveRecord::Base
  has_many :photos
  has_many :invitations
  belongs_to :user

  ACTIVE = true
  INACTIVE = false

  def self.actives
  	self.where(active: ACTIVE)
  end

  def self.find_for_state state, user_id
  	self.where(invitations: {:state => state, :user_id => user_id}).order(created_at: :desc)
  end

  def self.invitations_to user_id
  	self.where(invitations: {user_id: user_id})
  end

  def self.search_event_name text
  	self.where("name like ? ", "%#{text}%")
  end

  def self.join_invitations
  	self.select("events.*").joins(:invitations)
  end

  def self.my_events user_id
  	self.where(user_id: user_id)
  end

  def self.find_to_active text, user
    sql = "SELECT events.* FROM events INNER JOIN invitations
    ON invitations.event_id = events.id
    WHERE (name like ?) AND invitations.user_id = ? AND events.active = true
    UNION
    SELECT events.* FROM events WHERE (name like ?) AND events.user_id = ?
    ORDER BY 5 DESC"
    self.find_by_sql([sql, text, user, text, user])
  end

end
