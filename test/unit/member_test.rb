# == Schema Information
#
# Table name: members
#
#  id                      :integer          not null, primary key
#  club_id                 :integer
#  first_name              :string(255)
#  last_name               :string(255)
#  email                   :string(255)
#  ugent_nr                :string(255)
#  sex                     :string(255)
#  phone                   :string(255)
#  date_of_birth           :date
#  home_address            :string(255)
#  studenthome_address     :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  photo_file_name         :string(255)
#  photo_content_type      :string(255)
#  photo_file_size         :integer
#  photo_updated_at        :datetime
#  isic_newsletter         :boolean
#  isic_mail_card          :boolean
#  enabled                 :boolean          default(FALSE)
#  last_registration       :integer
#  home_street             :string(255)
#  home_postal_code        :string(255)
#  home_city               :string(255)
#  studenthome_street      :string(255)
#  studenthome_postal_code :string(255)
#  studenthome_city        :string(255)
#

require 'test_helper'
require 'open-uri'

class MemberTest < ActiveSupport::TestCase
  verify_fixtures Member

  def setup
    @url = "http://placehold.it/210x270.gif"
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

  test "should find member with same student number" do
    result = Member.member_for_ugent_nr(@member.ugent_nr, @member.club)
    assert_equal @member, result
  end
end
