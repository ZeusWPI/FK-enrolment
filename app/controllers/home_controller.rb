class HomeController < ApplicationController
  def index
    @clubs = Club.order(:full_name).all
  end
end
