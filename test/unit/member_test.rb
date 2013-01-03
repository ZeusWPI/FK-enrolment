require 'test_helper'
require 'open-uri'

class MemberTest < ActiveSupport::TestCase
  verify_fixtures Member

  def setup
    @url = "http://kelder.zeus.ugent.be/~javache/fk-test.gif"
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

  test "should request card in isic export" do
    @member = members(:nudded)
    @member.cards.destroy_all

    result = Member.find_all_for_isic_export(@member.club.id, "request")
    assert_equal [@member], result
    assert_nil result.first.current_card

    export = IsicExport.new
    export.club_id = @member.club_id
    export.export_type = 'request'
    export.members = result.map(&:id)
    export.generate
    export.save!

    @member.reload
    assert_equal "requested", @member.current_card.isic_status
  end

  test "should not include unpaid cards in isic export" do
    @member = members(:nudded)

    result = Member.find_all_for_isic_export(@member.club.id, "request_paid")
    assert_equal [], result
  end

  test "should filter isic export after processing" do
    @member = members(:nudded)
    @member.current_card.destroy

    result = Member.find_all_for_isic_export(@member.club.id, "request")
    assert_equal [@member], result
    assert_nil result.first.current_card

    export = IsicExport.new
    export.club_id = @member.club_id
    export.export_type = 'request'
    export.members = result.map(&:id)
    export.generate
    export.save!

    @member.reload
    assert_equal "revalidate", @member.current_card.isic_status
    assert_equal [], export.members
  end
end
