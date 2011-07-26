class RegistrationController < ApplicationController
  def index
  end

  def general
    @member = Member.new
  end

  def general_submit
    @member = Member.new(params[:member])
    if @member.save
      # redirect to next_step based on club preferences
    else
      render 'general' 
    end
  end

  def photo
  end

  def isic
  end

  def success
  end

end
