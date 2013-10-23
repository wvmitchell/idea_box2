require './test/test_helper'
require './lib/ideabox/user.rb'

class UserTest < MiniTest::Test

  def test_a_user_can_be_created
    pass = Digest::MD5.digest('potato')
    user = User.new('wvmitchell', 'wvmitchell@gmail.com', pass)
    assert_equal 'wvmitchell', user.username
    assert_equal 'wvmitchell@gmail.com', user.email
    assert_equal pass, user.password
  end

  def test_a_user_has_an_id
    pass = Digest::MD5.digest('potato')
    user = User.new('wvmitchell', 'wvmitchell@gmail.com', pass)
    user.id = 1
    assert_equal 1, user.id
  end
end
