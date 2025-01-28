require 'test_helper'

class AdminPanel::SettingsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_panel_settings_index_url
    assert_response :success
  end

  test 'should get update' do
    get admin_panel_settings_update_url
    assert_response :success
  end
end
