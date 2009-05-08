require 'test_helper'

class RecordsControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    records = assigns(:records)
    assert_not_nil records
    assert_equal(2, records.length)
  end

  def test_should_get_new
    get :new
    assert_not_nil(:record)
    assert_response :success
  end

  def test_should_create_record
    assert_difference('Record.count') do
      post :create, :record => {:name => "testname" }
    end

    record = assigns(:record)
    assert_redirected_to record_path(record)
  end

  def test_should_show_record
    get :show, :id => records(:one).to_param
    assert_response :success
    record = assigns(:record)
    assert_equal("The Heart of the Congoes", record.name)
  end

  def test_should_get_edit
    get :edit, :id => records(:one).to_param
    assert_response :success
    assert_equal(1, assigns(:record).id)
  end

  def test_should_update_record
    updated_name = "roots of david"
    put :update, :id => records(:one).to_param, :record => {:name => updated_name}
    record = assigns(:record)
    assert_redirected_to record_path(record)
    assert_equal(updated_name, record.name)
  end

  def test_should_destroy_record
    assert_difference('Record.count', -1) do
      delete :destroy, :id => records(:one).to_param
    end
    assert_raise(ActiveRecord::RecordNotFound) {Record.find(1)}
    assert_redirected_to records_path
  end

end
