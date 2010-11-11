class HomeController < ApplicationController

  def index
    @meetups = Meetup.find(:all, :order => "happening_at DESC")
    @presentations = Presentation.find(:all, :order => "created_at DESC", :limit => 10)
    @no_title = true
    respond_to do |format|
      format.html { render :index }
    end
  end

end
