class TimelinesController < ApplicationController

  before_filter :authenticate_user!

  after_create :tweet_timeline

  def create
    @timeline = current_user.timelines.new(params[:timeline])
    if @timeline.valid? and @timeline.save
      flash[:notice] = "Message successfuly posted to timeline"
    else
      flash[:error] = "Message must be shorter than 256 characters"
    end
    redirect_to :back
  end

end
