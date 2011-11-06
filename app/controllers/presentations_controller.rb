class PresentationsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :index ]

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @presentations = user.presentations.find(:all, :order => "created_at DESC")
    else
      @presentations = Presentation.find(:all, :order => "created_at DESC")
    end
    @meetups = Meetup.all
    @title = "Talks history"
    respond_to do |format|
      format.html { render :index }
    end
  end

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
      flash[:notice] = "Thank you for submitting your talk!"
      redirect_to meetup_path(@presentation.meetup_id)
    else
      render :new
    end
  end

  def show
    @presentation = Presentation.find(params[:id])
    @title = "#{@presentation.user.account.name} - #{@presentation.name}"
    respond_to do |format|
      format.html { render :show }
    end
  end

  def vote
    @presentation = Presentation.find(params[:id])
    if @presentation.votes.any? { |v| v.user.eql?(current_user) }
      flash[:error] = "Sorry, but you already voted for this presentation"
    elsif @presentation.user.eql?(current_user)
      flash[:error] = "Sorry, you can't vote for your own presentation"
    else
      @presentation.give_vote!(current_user)
      flash[:notice] = "Thank you for you vote!"
    end
    redirect_to :back
  end

end
