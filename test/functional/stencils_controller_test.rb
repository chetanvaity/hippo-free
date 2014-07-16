require 'test_helper'

class StencilsControllerTest < ActionController::TestCase
  setup do
    @stencil = stencils(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stencils)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stencil" do
    assert_difference('Stencil.count') do
      post :create, stencil: @stencil.attributes
    end

    assert_redirected_to stencil_path(assigns(:stencil))
  end

  test "should show stencil" do
    get :show, id: @stencil
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stencil
    assert_response :success
  end

  test "should update stencil" do
    put :update, id: @stencil, stencil: @stencil.attributes
    assert_redirected_to stencil_path(assigns(:stencil))
  end

  test "should destroy stencil" do
    assert_difference('Stencil.count', -1) do
      delete :destroy, id: @stencil
    end

    assert_redirected_to stencils_path
  end
end
