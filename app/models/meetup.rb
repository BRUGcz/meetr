class Meetup < ActiveRecord::Base
  belongs_to :user
  has_many :meetup_users
  has_many :attendees, :class_name => 'User', :through => :meetup_users, :source => :user
  has_many :presentations
  has_many :timelines


  validates :name, :presence => true, :length => { :minimum => 4 }, :uniqueness => true
  validates :location, :presence => true
  validates :happening_at, :date => { :after => Time.now, :before => Time.now + 3.months }

  def human_date
    self.happening_at.strftime("%d %B %Y")
  end

  def add_attendee(user)
    if MeetupUser.find(:first, :conditions => { :user_id => user.id, :meetup_id => self.id})
      return false
    else
      self.attendees << user
    end
  end

  def attendee(user)
    MeetupUser.find(:first, :conditions => { :user_id => user.id, :meetup_id => self.id})
  end

  def user_attends?(user)
    mu = attendee(user)
    return false unless mu
    return false unless mu.is_attending
    return true
  end

  def num_of_attendees
    self.meetup_users.count(:conditions => { :is_attending => true })
  end

end
