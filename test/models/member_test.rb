# == Schema Information
#
# Table name: members
#
#  id                      :integer          not null, primary key
#  club_id                 :integer
#  first_name              :string
#  last_name               :string
#  email                   :string
#  ugent_nr                :string
#  sex                     :string
#  phone                   :string
#  date_of_birth           :date
#  home_address            :string
#  studenthome_address     :string
#  created_at              :datetime
#  updated_at              :datetime
#  photo_file_name         :string
#  photo_content_type      :string
#  photo_file_size         :integer
#  photo_updated_at        :datetime
#  isic_newsletter         :boolean
#  isic_mail_card          :boolean
#  enabled                 :boolean          default(FALSE)
#  last_registration       :integer
#  home_street             :string
#  home_postal_code        :string
#  home_city               :string
#  studenthome_street      :string
#  studenthome_postal_code :string
#  studenthome_city        :string
#  card_type_preference    :string
#

require 'test_helper'
require 'open-uri'

class MemberTest < ActiveSupport::TestCase
  verify_fixtures Member

  def setup
    @url = "http://placehold.it/210x270.png"
    File.open(File.join(fixture_path, "210x270.png"), 'rb') { |f| @photo = f.read }
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
