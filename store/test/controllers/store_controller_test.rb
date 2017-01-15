require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', minimum: 4
    assert_select '#columns #side #time', /\A\d\d\d\d/
    assert_select '#main .entry', 3
    assert_select 'h3', 'MySecondString'
    assert_select '.price', /&#8364;[,\d]+\.\d\d/
  end

end
