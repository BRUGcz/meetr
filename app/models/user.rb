class User < ActiveRecord::Base

  has_many :user_tokens
  has_one :account

  has_many :timelines
  has_many :meetups
  has_many :presentations
  has_many :votes
  has_many :meetup_users
  has_many :attendances, :class_name => 'Meetup', :through => :meetup_users, :source => :meetup

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  after_create :create_user_account

  def create_user_account
    Account.create(:name => "#{self.email.split('@').first}", :url => "", :user_id => self.id)
  end

  def create_account!(name, url)
    self.account.update_attributes(:name => name, :url => url)
  end

  def to_s
    self.account.name
  end

end
