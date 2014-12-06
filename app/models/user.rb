class User < ActiveRecord::Base
  has_many :pictures

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

end