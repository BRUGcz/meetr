class Presentation < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  has_many :votes

  validates :name, :presence => true, :length => { :minimum => 4 }
  validates :meetup_id, :presence => true
  validates_exclusion_of :duration, :in => %w(600 1200 2400),
    :message => "Presentation duration must by 10,20 or 40 minutes."

  def to_html
    Maruku.new(self.description).to_html
  end

end
