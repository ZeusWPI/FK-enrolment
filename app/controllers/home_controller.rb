class HomeController < ApplicationController
  def index
    @clubs = Club.using(:website).all
  end
end
