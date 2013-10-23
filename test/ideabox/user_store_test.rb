require './test/test_helper'
require './lib/ideabox/user.rb'
require './lib/ideabox/user_store.rb'

class UserStoreTest < MiniTest::Test

  def teardown
    UserStore.delete_all
  end

  def test_create_and_retrive_user
    id = UserStore.save User.new('wvm','wvm@gm.co','pass')
    assert_equal 1, UserStore.all.count
    id2 = UserStore.save User.new("bob", 'bob@bob.co', 'pass')
    assert_equal 2, UserStore.all.count

    user = UserStore.find(id)
    assert_equal 'wvm', user.username
    assert_equal 'wvm@gm.co', user.email
    assert_equal 'pass', user.password
    user = UserStore.find(id2)
    assert_equal 'bob', user.username
    assert_equal 'bob@bob.co', user.email
    assert_equal 'pass', user.password
  end

  def test_delete_all_empties_users
    UserStore.save User.new('wvm','wvm@gm.co','pass')
    UserStore.save User.new("bob", 'bob@bob.co', 'pass')

    assert_equal 2, UserStore.all.count
    UserStore.delete_all
    assert_equal 0, UserStore.all.count
  end

  def test_delete_removes_single_user
    id = UserStore.save User.new('wvm','wvm@gm.co','pass')
    id2 = UserStore.save User.new("bob", 'bob@bob.co', 'pass')
    UserStore.delete(id)

    assert_equal 1, UserStore.all.count
  end

  def test_users_cannot_have_same_id
    id = UserStore.save User.new('wvm','wvm@gm.co','pass')
    id2 = UserStore.save User.new("bob", 'bob@bob.co', 'pass')
    UserStore.delete(id)
    UserStore.save User.new("j","b","p")
    assert_equal 2, UserStore.all.count
    refute_equal UserStore.all[0].id, UserStore.all[1].id
  end

  def test_find_by_username
    UserStore.save User.new('wvm','wvm@gm.co','pass')
    UserStore.save User.new("bob", 'bob@bob.co', 'pass')
    user = UserStore.find_by_username('bob')
    assert_equal 'bob', user.username
    user = UserStore.find_by_username('wvm')
    assert_equal 'wvm', user.username
  end

end
