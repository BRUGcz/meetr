class UsersController < ApplicationController

  def email
    @user = current_user
    if @user.update_attribute('email', params[:user][:email])
      flash[:notice] = "Your profile has been updated."
      redirect_to account_url(@user.account)
    else
      render :action => 'edit'
    end
  end

end
