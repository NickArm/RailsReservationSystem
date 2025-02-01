require 'test_helper'

class AdminPanel::InvoicesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_panel_invoices_index_url
    assert_response :success
  end

  test 'should get show' do
    get admin_panel_invoices_show_url
    assert_response :success
  end
end
