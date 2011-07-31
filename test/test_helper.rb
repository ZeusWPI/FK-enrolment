ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def self.verify_fixtures(clazz)
    test "#{clazz.name} fixtures should validate" do
      clazz.all.map { |o| assert o.valid?, o.errors.full_messages.join("\n") }
    end
  end

  def params_for_api(params = {}, format = "json", club = @club)
    params[:format] = format unless params[:format]
    params[:key] = club.api_key unless params[:key]
    params
  end
end
