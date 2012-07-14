require 'test_helper'
require 'open-uri'

class MemberTest < ActiveSupport::TestCase
  verify_fixtures Member

  def setup
    @url = "http://placehold.it/210x270"
    File.open(File.join(fixture_path, "210x270.gif"), 'rb') { |f| @photo = f.read }
    @member = members(:javache)
  end

  def verify(test)
    assert_equal @photo.length, test.size
    geometry = Paperclip::Geometry.from_file(test.path(:original))
    original_geometry = Paperclip::Geometry.parse("210x270")
    assert_equal original_geometry.to_s, geometry.to_s
  end

  test "should get full name" do
    assert_equal "Pieter De Baets", @member.name
  end

  test "should get photo from url" do
    @member.photo_url = @url
    @member.save
    verify(@member.photo)
  end

  test "should show error when an invalid url is parsed" do
    @member.photo_url = "C:\\Users\\Jos\\foto.jpg"
    assert !@member.save
  end

  test "should create photo from base64" do
    @member.photo_base64 = Base64.encode64(@photo)
    @member.save
    verify(@member.photo)
  end

  test "should disable member" do
    @member.disable
    assert !@member.enabled
  end
end
