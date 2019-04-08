require 'test_helper'

class Api::V1ControllerTest < ActionDispatch::IntegrationTest
  test "should get audio_files" do
    get api_v1_audio_files_url
    assert_response :success
  end

end
