require 'open-uri'

class RegistrationController < ApplicationController
  respond_to :html

  before_filter :load_club
  def load_club
    @club = Club.using([:website, :fkbooks])
                .where('LOWER(internal_name) = ?', params[:club]).first!
  end

  # Load member set in session or create a new one
  before_filter :load_member, :except => [:index]
  def load_member
    if session[:member_id]
      begin
        @member = Member.find(session[:member_id])
      rescue ActiveRecord::RecordNotFound
      end
    elsif action_name == "general"
      @member = Member.new
    end

    if !@member
      # Return to start to create a new member
      session[:member_id] = nil
      redirect_to registration_root_path(@club)
    else
      # Always set the member to the club from the current club-param
      # so the record ends up in the right place, even when the url changes
      @member.club = @club if @member
    end
  end

  def index
  end

  def general
    @member.attributes = params[:member]

    # Override properties if they're already set through CAS
    @cas_authed = !session[:cas_user].blank?
    if @cas_authed
      attributes = session[:cas_extra_attributes]
      @member.first_name = attributes["givenname"]
      @member.last_name = attributes["surname"]
      @member.ugent_nr = attributes["ugentStudentID"]
    end

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
    method = :file

    # Check for base64-upload of image (via webcam)
    if params[:member] && !params[:member][:webcam].blank?
      sio = StringIO.new(Base64.decode64(params[:member][:webcam]))
      sio.original_filename = "snapshot.jpg"
      sio.content_type = "image/jpeg"
      @member.photo = sio

      method = :webcam
    end

    # Check for link to external image
    if params[:member] && !params[:member][:url].blank?
      # Don't download longer than 10 seconds
      Timeout::timeout(10) do
        uri = URI.parse(params[:member][:url])
        @member.photo = uri.open if uri.respond_to? :open
      end

      method = :url
    end

    if @member.update_attributes(params[:member])
      if @member.cropping? || method == :webcam
        redirect_to registration_success_path(@club)
      end
    end
  end

  def success
    session[:member_id] = nil

    # Redirect to FK-books
    if @club.registration_method == "fkbooks"
      # TODO: redirect to www.fkgent.be/fkbooks/zeus_return_catcher/<member_id>/<type>/<key>
      with special key
    end
  end
end
