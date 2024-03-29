class Meetup < ActiveRecord::Base
  belongs_to :user
  has_many :meetup_users
  has_many :attendees, :class_name => 'User', :through => :meetup_users, :source => :user, :order => "created_at DESC"
  has_many :presentations, :order => "created_at DESC"
  has_many :timelines, :order => "created_at DESC"


  validates :name, :presence => true, :length => { :minimum => 4 }, :uniqueness => true
  validates :location, :presence => true
  validates :happening_at, :date => { :after => Time.now, :before => Time.now + 3.months }

  after_create :add_creator_to_attendees
  after_update :add_update_timeline

  def self.upcomming
    self.find(:all, :conditions => "happening_at > NOW()")
  end

  def human_date
    self.happening_at.strftime("%d %B %Y")
  end

  def add_attendee(user)
    if MeetupUser.find(:first, :conditions => { :user_id => user.id, :meetup_id => self.id})
      return false
    else
      self.attendees << user
      user.timelines.create(:meetup_id => self.id, :message => "is attending #{self.name}")
    end
  end

  def attendee(user)
    MeetupUser.find(:first, :conditions => { :user_id => user.id, :meetup_id => self.id})
  end

  def presenters
    self.presentations.collect { |p| p.user }
  end

  def update_attendee(user, attending = true)
    mu = MeetupUser.find(:first, :conditions => { :user_id => user.id, :meetup_id => self.id})
    mu.update_attributes!(:is_attending => attending)
    if attending
      user.timelines.create(:meetup_id => self.id, :message => "is attending #{self.name}")
    else
      user.timelines.create(:meetup_id => self.id, :message => "is not attending #{self.name}")
    end
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

  private

  def add_creator_to_attendees
    self.add_attendee(self.user)
  end

  def add_update_timeline
    self.user.timelines << Timeline.new(:meetup_id => self.id, :message => "just changed details about #{self.name}")
  end

end
