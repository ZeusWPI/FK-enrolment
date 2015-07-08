ENV["RAILS_ENV"] ||= "test"

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
    test "fixtures for #{clazz.name} should validate" do
      clazz.all.map { |o| assert o.valid?, o.inspect.to_s + "\n" + o.errors.full_messages.join("\n") }
    end
  end

  def self.generate_card_number(club, number)
    if club.is_a? Symbol
      club_id = ActiveRecord::FixtureSet.identify(club)
    else
      club_id = club.id
    end

    ((Member.current_academic_year % 100) * 100 + (club_id % 100)) * 10000 + number
  end

  def params_for_api(params = {}, format = "json", club = @club)
    params[:format] ||= format
    params[:key] ||= club.api_key
    params
  end
end
