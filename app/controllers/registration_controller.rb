class RegistrationController < ApplicationController
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
