require 'test_helper'

class IsicExportTest < ActiveSupport::TestCase
  verify_fixtures IsicExport

  def setup
    @export = isic_exports(:one)

    @member = members(:nudded)
    File.open(File.join(fixture_path, "photo.jpg")) do |f|
      @member.photo = f
    end
    @member.save
  end

  test "should lookup all members" do
    assert_equal [@member], @export.full_members
  end

  test "should generate export spreadsheet" do
    IsicExport.delete_all

    @export = IsicExport.new
    @export.members = [@member.id]
    @export.generate
    @export.save!

    assert File.exists?(@export.data.path)

    book = Spreadsheet.open @export.data.path
    assert_equal 2, book.worksheet(0).row_count
  end

  test "should generate export zip" do
    IsicExport.delete_all

    @export = IsicExport.new
    @export.members = [@member.id]
    @export.generate
    @export.save!

    assert File.exists?(@export.photos.path)
    assert_equal ["#{@member.id}.jpg"], Zippy.list(@export.photos.path).to_a
  end
end
