class PresentationsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @meetup = Meetup.find(params[:presentation][:meetup_id])
    @presentation = current_user.presentations.new(:meetup_id => @meetup.id)
    respond_to do |format|
      format.html { render :new }
    end
  end

  def create
    @presentation = current_user.presentations.new(params[:presentation])
    if @presentation.valid? and @presentation.save
      @presentation.meetup.timelines << Timeline.new(:user_id => current_user, 
        :message => "has just submitted #{@presentation.name} talk!")
      flash[:notice] = "Thank you for submitting your talk!"
      redirect_to meetup_path(@presentation.meetup_id)
    else
      render :new
    end
  end

  def show
    @presentation = Presentation.find(params[:id])
    respond_to do |format|
      format.html { render :show }
    end
  end

  def vote
    @presentation = Presentation.find(params[:id])
    if @presentation.votes.any? { |v| v.user.eql?(current_user) }
      flash[:error] = "Sorry, but you already voted for this presentation"
    else
      current_user.votes.create(:presentation_id => @presentation.id)
      @presentation.meetup.timelines << Timeline.new(:user_id => current_user, 
        :message => "just voted for #{@presentation.name}")
      flash[:notice] = "Thank you for you vote!"
    end
    redirect_to :back
  end

end
