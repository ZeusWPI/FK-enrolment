class RegistrationController < ApplicationController
  before_filter :load_club

  def load_club
    @club = Club.where(:internal_name => params[:club])
    unless @club
      render :status => :not_found
    end
  end

  def index
  end

  def general
    if params[:member]
      @member = Member.new(params[:member])
      if @member.save
        # redirect to next_step based on club preferences
      else

      end
    else
      @member = Member.new
    end
  end


  def photo
  end

  def isic
  end

  def success
  end

end
