class HomeController < ApplicationController
  def index
    @clubs = Club.using([:website, :fkbooks]).order(:full_name).all
  end
end
