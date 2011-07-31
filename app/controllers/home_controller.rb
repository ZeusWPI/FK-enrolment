class HomeController < ApplicationController
  def index
    @clubs = Club.using(:website).order(:full_name).all
  end
end
