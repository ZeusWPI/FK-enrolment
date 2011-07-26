class RegistrationController < ApplicationController
  before_filter :load_club
  respond_to :html

  before_filter :load_member, :only => [:photo, :isic, :success]

  def load_club
    @club = Club.using(:website).where('LOWER(internal_name) = ?', params[:club]).first!
  end

  def load_member
    @member = Member.find(session[:member_id])
  end

  def index
  end

  def general
    @member = Member.new(params[:member])
    @member.club = @club
    if params[:member] && @member.save
      session[:member_id] = @member.id
      # redirect to next_step based on club preferences
      if @club.uses_isic
        redirect_to registration_photo_path(@club)
      else
        redirect_to registration_success_path(@club)
      end
    end
  end

  def photo
  end

  def isic
  end

  def success
  end

end
