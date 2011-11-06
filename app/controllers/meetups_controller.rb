class MeetupsController < ApplicationController
   before_filter :authenticate_user!, :except => [ :show ]

   def index
     @meetups = Meetup.find(:all, :order => "created_at DESC ")
     @presentations = Presentation.find(:all, :order => "created_at DESC", :limit => 8)
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
       flash[:notice] = "You successfully added yourself to this meetup"
     else
       if meetup.user_attends?(current_user)
         flash[:error] = "You already attending this meetup"
       else
         meetup.update_attendee(current_user, true)
         flash[:notice] = "You successfully added yourself to this meetup"
       end
     end
     redirect_to meetup_path(meetup.id)
   end

   def not_attend
     meetup = Meetup.find(params[:id])
     meetup.add_attendee(current_user)
     meetup.update_attendee(current_user, false)
     flash[:error] = "You successfully removed yourself to this meetup"
     redirect_to meetup_path(meetup.id)
   end

end
