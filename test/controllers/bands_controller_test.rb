require "test_helper"

class BandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @band = bands(:one)
  end

  test "should get index" do
    get bands_url
    assert_response :success
  end

  test "should get new" do
    get new_band_url
    assert_response :success
  end

  test "should create band" do
    assert_difference("Band.count") do
      post bands_url, params: { band: { band_bandcamp_link: @band.band_bandcamp_link, band_description: @band.band_description, band_email: @band.band_email, band_ffo: @band.band_ffo, band_instagram_link: @band.band_instagram_link, band_location: @band.band_location, band_name: @band.band_name, genre: @band.genre } }
    end

    assert_redirected_to band_url(Band.last)
  end

  test "should show band" do
    get band_url(@band)
    assert_response :success
  end

  test "should get edit" do
    get edit_band_url(@band)
    assert_response :success
  end

  test "should update band" do
    patch band_url(@band), params: { band: { band_bandcamp_link: @band.band_bandcamp_link, band_description: @band.band_description, band_email: @band.band_email, band_ffo: @band.band_ffo, band_instagram_link: @band.band_instagram_link, band_location: @band.band_location, band_name: @band.band_name, genre: @band.genre } }
    assert_redirected_to band_url(@band)
  end

  test "should destroy band" do
    assert_difference("Band.count", -1) do
      delete band_url(@band)
    end

    assert_redirected_to bands_url
  end
end
