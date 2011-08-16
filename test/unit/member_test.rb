require 'test_helper'
require 'open-uri'

class MemberTest < ActiveSupport::TestCase
  verify_fixtures Member

  def setup
    @url = "http://dummyimage.com/100x100"
    @member = members(:javache)
    @photo = open(@url).read
    @geometry = Paperclip::Geometry.parse("100x100")
  end

  def verify(test)
    assert_equal @photo.length, test.size
    geometry = Paperclip::Geometry.from_file(test.path(:original))
    assert_equal @geometry.to_s, geometry.to_s
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
end
