class User < ActiveRecord::Base

  has_many :user_tokens
  has_one :account

  has_many :timelines
  has_many :meetups
  has_many :presentations
  has_many :votes
  has_many :attendances, :class_name => 'Meetup', :through => :meetup_users

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def create_account!(name, url)
    Account.create(:name => name, :url => url, :user_id => self.id)
  end

  def to_s
    self.account.name
  end

end
