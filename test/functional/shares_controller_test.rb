require 'test_helper'

class SharesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create share" do
    assert_difference('Share.count') do
      post :create, :share => { }
    end

    assert_redirected_to share_path(assigns(:share))
  end

  test "should show share" do
    get :show, :id => shares(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => shares(:one).id
    assert_response :success
  end

  test "should update share" do
    put :update, :id => shares(:one).id, :share => { }
    assert_redirected_to share_path(assigns(:share))
  end

  test "should destroy share" do
    assert_difference('Share.count', -1) do
      delete :destroy, :id => shares(:one).id
    end

    assert_redirected_to shares_path
  end
end
