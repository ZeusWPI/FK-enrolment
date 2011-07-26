class RegistrationController < ApplicationController
  before_filter :load_club
  respond_to :html

  def load_club
    @club = Club.find_by_internal_name!(params[:club])
  end

  def index
  end

  def general
    @member = Member.new(params[:member])
    @member.club = @club
    if params[:member] && @member.save
      # redirect to next_step based on club preferences

    end
  end

  def photo
  end

  def isic
  end

  def success
  end

end
