require File.dirname(__FILE__) + '/../test_helper'

class MstUserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :mst_users

  # signup test
  def test_should_create_mst_user
    assert_difference 'MstUser.count' do
      mst_user = create_mst_user
      assert !mst_user.new_record?, "#{mst_user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_user_name
    assert_no_difference 'MstUser.count' do
      u = create_mst_user(:user_name => nil)
      assert u.errors.on(:user_name)
    end
  end

=begin
  def test_should_require_password
    assert_no_difference 'MstUser.count' do
      u = create_mst_user(:password => nil)
      assert u.errors.on(:password)
    end
  end


  def test_should_require_password_confirmation
    assert_no_difference 'MstUser.count' do
      u = create_mst_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end
=end

  def test_should_require_email
    assert_no_difference 'MstUser.count' do
      u = create_mst_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    mst_users(:quentin).update_attributes(:password => 'new password')
    assert_equal mst_users(:quentin), MstUser.authenticate('quentin@example.com', 'new password')
  end

  def test_should_not_rehash_password
    mst_users(:quentin).update_attributes(:login_id => 'quentin2@example.com')
    assert_equal mst_users(:quentin), MstUser.authenticate('quentin2@example.com', 'test')
  end

  def test_should_authenticate_mst_user
    assert_equal mst_users(:quentin), MstUser.authenticate('quentin@example.com', 'test')
  end

  def test_should_set_remember_token
    mst_users(:quentin).remember_me
    assert_not_nil mst_users(:quentin).remember_token
    assert_not_nil mst_users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    mst_users(:quentin).remember_me
    assert_not_nil mst_users(:quentin).remember_token
    mst_users(:quentin).forget_me
    assert_nil mst_users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    mst_users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil mst_users(:quentin).remember_token
    assert_not_nil mst_users(:quentin).remember_token_expires_at
    assert mst_users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    mst_users(:quentin).remember_me_until time
    assert_not_nil mst_users(:quentin).remember_token
    assert_not_nil mst_users(:quentin).remember_token_expires_at
    assert_equal mst_users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    mst_users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil mst_users(:quentin).remember_token
    assert_not_nil mst_users(:quentin).remember_token_expires_at
    assert mst_users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_my_name_for_user_name
    user = create_mst_user()
    assert_equal user.my_name, user.user_name
  end

  def test_my_name_for_email
    user = create_mst_user({:user_name => nil})
    assert_equal user.my_name, user.email
  end



protected
  def create_mst_user(options = {})
    record = MstUser.signup({:email => 'quire@example.com', :user_name => 'quire', :company_name => '9arrows'}.merge(options))
    record.save
    record
  end
end
