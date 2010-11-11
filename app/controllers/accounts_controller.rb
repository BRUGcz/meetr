class AccountsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]

  def update
    account = current_user.account
    account.update_attributes!(params[:account])
    flash[:notice] = "Your profile was updated!"
    redirect_to account_url(account.id)
  end

  def show
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html { render :show }
    end
  end

end
