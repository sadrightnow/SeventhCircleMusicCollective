require "application_system_test_case"

class BandsTest < ApplicationSystemTestCase
  setup do
    @band = bands(:one)
  end

  test "visiting the index" do
    visit bands_url
    assert_selector "h1", text: "Bands"
  end

  test "should create band" do
    visit bands_url
    click_on "New band"

    fill_in "Band bandcamp link", with: @band.band_bandcamp_link
    fill_in "Band description", with: @band.band_description
    fill_in "Band email", with: @band.band_email
    fill_in "Band ffo", with: @band.band_ffo
    fill_in "Band instagram link", with: @band.band_instagram_link
    fill_in "Band location", with: @band.band_location
    fill_in "Band name", with: @band.band_name
    fill_in "Genre", with: @band.genre
    click_on "Create Band"

    assert_text "Band was successfully created"
    click_on "Back"
  end

  test "should update Band" do
    visit band_url(@band)
    click_on "Edit this band", match: :first

    fill_in "Band bandcamp link", with: @band.band_bandcamp_link
    fill_in "Band description", with: @band.band_description
    fill_in "Band email", with: @band.band_email
    fill_in "Band ffo", with: @band.band_ffo
    fill_in "Band instagram link", with: @band.band_instagram_link
    fill_in "Band location", with: @band.band_location
    fill_in "Band name", with: @band.band_name
    fill_in "Genre", with: @band.genre
    click_on "Update Band"

    assert_text "Band was successfully updated"
    click_on "Back"
  end

  test "should destroy Band" do
    visit band_url(@band)
    click_on "Destroy this band", match: :first

    assert_text "Band was successfully destroyed"
  end
end
