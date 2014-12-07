class User < ActiveRecord::Base
  has_many :pictures

  validates_presence_of :username, :email, :password, unless: :is_guest?
 
  def self.new_guest
    new { |u| u.is_guest = true }
  end

  def move_to(user)
    User.update_all(id: user.id)
  end

  def name
    is_guest ? "Guest" : username
  end

end