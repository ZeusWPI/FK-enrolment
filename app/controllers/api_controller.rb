class ApiController < ApplicationController
  respond_to :xml, :json
  # TODO: respond_to export using csv, xls

  def test
    respond_with(status: "ok")
  end
end