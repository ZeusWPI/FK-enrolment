class RegistrationController < ApplicationController
  before_filter :load_club
  respond_to :html

  before_filter :load_member, :only => [:photo, :isic, :success]

  def load_club
    @club = Club.using(:website).where('LOWER(internal_name) = ?', params[:club]).first!
  end

  def load_member
    # TODO: clear the member_id from session after registration
    if(session[:member_id])
      begin
        @member = Member.find(session[:member_id])
      rescue
        redirect_to registration_root_path(@club)
      end
    end
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
        # TODO: eerst naar isic pagina gaan, foto is daarna logischer
        redirect_to registration_photo_path(@club)
      else
        redirect_to registration_success_path(@club)
      end
    end
  end

  def photo
    if @member.update_attributes(params[:member])
      # redirect_to registration_isic_path(@club)
    end
  end

  def isic
    if request.post?
      redirect_to registration_photo_path(@club)
    end
  end

  def success
  end

end
