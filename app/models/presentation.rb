class Presentation < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  has_many :votes

  validates :name, :presence => true, :length => { :minimum => 4 }
  validates :meetup_id, :presence => true
  validates_exclusion_of :duration, :in => %w(600 1200 2400),
    :message => "Presentation duration must by 10,20 or 40 minutes."

  after_create :add_timeline_entry

  def give_vote!(user)
    self.votes << Vote.new(:user_id => user.id)
    user.timelines << Timeline.new(:meetup_id => self.meetup_id, :message => "just voted for #{self.name}")
  end

  def to_html
    Maruku.new(self.description).to_html
  end

  private

  def add_timeline_entry
    self.user.timelines << Timeline.new(:meetup_id => self.meetup_id, :message => "just submitted a new presentation #{self.name}")
  end

end
