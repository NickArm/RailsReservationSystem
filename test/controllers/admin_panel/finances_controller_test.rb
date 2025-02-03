require 'test_helper'

class AdminPanel::FinancesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_panel_finances_index_url
    assert_response :success
  end

  test 'should get revenue_report' do
    get admin_panel_finances_revenue_report_url
    assert_response :success
  end

  test 'should get pending_payments' do
    get admin_panel_finances_pending_payments_url
    assert_response :success
  end

  test 'should get tax_report' do
    get admin_panel_finances_tax_report_url
    assert_response :success
  end

  test 'should get payment_methods' do
    get admin_panel_finances_payment_methods_url
    assert_response :success
  end

  test 'should get profitability' do
    get admin_panel_finances_profitability_url
    assert_response :success
  end
end
