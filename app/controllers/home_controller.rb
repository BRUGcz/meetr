class HomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.html { render :index }
    end
  end

end
