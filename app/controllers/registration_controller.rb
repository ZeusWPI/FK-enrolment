class RegistrationController < ApplicationController
  respond_to :html

  before_filter :load_club
  def load_club
    @club = Club.using(:website).where('LOWER(internal_name) = ?', params[:club]).first!
  end

  # Load member set in session or create a new one
  before_filter :load_member
  def load_member
    if session[:member_id]
      begin
        @member = Member.find(session[:member_id])
      rescue
        session[:member_id] = nil
        redirect_to registration_root_path(@club)
      end
    else
      @member = Member.new
    end

    # Always set the member to the club from the current club-param
    # so the record ends up in the right place, even when the url changes
    @member.club = @club
  end

  def index
  end

  def general
    @member.attributes = params[:member]

    if params[:member] && @member.save
      session[:member_id] = @member.id

      # Redirect to next_step based on club preferences
      if @club.uses_isic
        redirect_to registration_isic_path(@club)
      else
        redirect_to registration_success_path(@club)
      end
    end
  end

  def isic
    # TODO: save some stuff
    if request.put?
      redirect_to registration_photo_path(@club)
    end
  end

  def photo
    if @member.update_attributes(params[:member])
      if @member.cropping?
        redirect_to registration_success_path(@club)
      end
    end
  end

  def success
    session[:member_id] = nil
  end

end
