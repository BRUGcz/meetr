class MeetupsController < ApplicationController
   before_filter :authenticate_user!

   def index
     @meetups = Meetup.find(:all, :order => "created_at ASC")
     respond_to do |format|
       format.html { render :index }
     end
   end

   def new
     @meetup = current_user.meetups.new(params[:meetup])
     respond_to do |format|
       format.html { render :new }
     end
   end

   def create
     @meetup = current_user.meetups.new(params[:meetup])
     if @meetup.valid? and @meetup.save
       return redirect_to(meetups_path)
     else
       render :new
     end
   end

   def edit
     @meetup = current_user.meetups.find(params[:id])
     @submit_label = "Save changes"
     respond_to do |format|
       format.html { render :edit }
     end
   end

   def update
     @meetup = current_user.meetups.find(params[:id])
     @meetup.update_attributes(params[:meetup])
     if @meetup.valid? and @meetup.save
       return redirect_to(meetups_path)
     else
       render :edit
     end
   end

   def destroy
     @meetup = current_user.meetups.find(params[:id])
     @meetup.destroy!
     redirect_to meetups_path
   end

   def show
     @meetup = Meetup.find(params[:id])
     respond_to do |format|
       format.html { render :show }
     end
   end

   def attend
     meetup = Meetup.find(params[:id])
     if meetup.add_attendee(current_user)
        meetup.timelines << Timeline.new(:user_id => current_user, 
          :message => "has confirmed that he will attend #{meetup.name}")
       flash[:notice] = "You successfully added yourself to this meetup"
     else
       if meetup.user_attends?(current_user)
         flash[:error] = "You already attending this meetup"
       else
         meetup.attendee(current_user).update_attributes!(:is_attending => true)
         meetup.timelines << Timeline.new(:user_id => current_user, 
          :message => "has changed his mind and will attend #{meetup.name}")
         flash[:notice] = "You successfully added yourself to this meetup"
       end
     end
     redirect_to meetup_path(meetup.id)
   end

   def not_attend
     meetup = Meetup.find(params[:id])
     meetup.add_attendee(current_user)
     meet_user = MeetupUser.find(:first, :conditions => { :user_id => current_user.id, :meetup_id => meetup.id})
     meet_user.is_attending = false
     meet_user.save!
     meetup.timelines << Timeline.new(:user_id => current_user, 
          :message => "will not attend #{meetup.name}")
     flash[:error] = "You successfully removed yourself to this meetup"
     redirect_to meetup_path(meetup.id)
   end

end
