class HomeController < ApplicationController

  def index
    @meetups = Meetup.find(:all, :order => "happening_at DESC", :limit => 8)
    @presentations = Presentation.find(:all, :order => "created_at DESC", :limit => 8)
    @users = User.find(:all, :order => "created_at DESC", :limit => 8)
    @no_title = true
    respond_to do |format|
      format.html { render :index, :layout => 'dashboard' }
    end
  end

end
