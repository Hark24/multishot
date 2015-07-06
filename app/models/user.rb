class User < ActiveRecord::Base
  attr_accessor :requires_password
  before_create :generate_access_token
  has_many :authentications, dependent: :destroy
  has_many :events
  has_many :invitations
  has_many :photos

  has_many :contacts, :foreign_key => :user_1_id
  has_many :reverse_contacts, :class_name => :Contact,:foreign_key => :user_2_id
  has_many :users, :through => :contacts, :source => :user_2

  has_secure_password validations: false
  validates :email , presence: true

  def full_name
    first_name.nil? ? name : "#{first_name} #{last_name}"
  end

  def accept_terms_and_conditions
    self.accept_terms = true
    self.save
  end

  def self.all_except user_id
    where.not(id: user_id)
  end

  def facebook_friends
    unless self.authentications.first.nil?
      graph = Koala::Facebook::API.new(self.authentications.first.oauth_token)
      fb_friends = graph.get_connections("me", "friends").sort_by{ |u| u["name"] }
      existing_authentications = Authentication.where(uid: fb_friends.map{ |h| h["id"] }).includes([:user])
      return existing_authentications.map(&:user)
    else
      return []
    end
  end

  def save_contacts
    new_contacts = users + facebook_friends
    users = new_contacts.uniq
  end

  def self.from_omniauth auth
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def send_welcome_email
    generate_new_password
    ManageMailer.user_created(self).deliver
  end

  def confirm_account
    self.confirmed = true
    self.save
  end

  def generate_new_password
    self.password = SecureRandom.hex(4)
    self.confirmed = false
    self.save
  end

  def authorEvent
    first_name.nil? ? email : full_name
  end

  def self.find_user text, id
    self.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ? AND id != ?", text, text, text, id)
  end

  def self.find_text text
    self.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", text, text, text)
  end

  def verify_contact user_id
    no_contact = Contact.where(user_1_id: id, user_2_id: user_id).empty?
    !no_contact
  end

  private

  def generate_access_token
    loop do
      self.token = SecureRandom.hex.tr('+/=', 'xyz')
      break self.token unless self.class.find_by_confirmation_token(self.token)
    end
    # self.token = "#{SecureRandom.hex}"
  end


end
