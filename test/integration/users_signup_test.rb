require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  BAD_SIGNUP_INFO = { name: '',
                      email: 'user@invalid',
                      password: 'foo',
                      password_confirmation: 'bar' }

  GOOD_SIGNUP_INFO = { name: "Example User",
                       email: "user@example.com",
                       password: "password",
                       password_confirmation: "password" }

  #tests only invalid attributes passed in
  def reject_invalid_signup_attributes(bad_attrs)
    tainted_signup_info = GOOD_SIGNUP_INFO.merge(bad_attrs)
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: tainted_signup_info }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "reject invalid email" do
    reject_invalid_signup_attributes({ email: BAD_SIGNUP_INFO[:email]})
  end

  test "reject invalid password" do
    reject_invalid_signup_attributes({ password: BAD_SIGNUP_INFO[:password],
                                       password_confirmation: BAD_SIGNUP_INFO[:password_confirmation]})
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: GOOD_SIGNUP_INFO }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    #should have a first time messages
    assert_not flash.empty?
  end
end


#   test "invalid signup information" do
#     get signup_path
#     assert_no_difference 'User.count' do
#       post users_path, params: { user: {  name: '',
#                                           email: 'user@invalid',
#                                           password: 'foo',
#                                           password_confirmation: 'bar' } }
#     end
#     assert_template 'users/new'
#   end
# end
