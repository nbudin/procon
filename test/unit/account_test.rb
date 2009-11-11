require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < ActiveSupport::TestCase
  fixtures :accounts
  fixtures :email_addresses

  def test_primary_email
    joe = accounts(:joe)
    assert_equal 2, joe.email_addresses.length
    assert_equal "joe@test.com", joe.primary_email_address
  end
  
  def test_password
    newbie = Account.new
    newbie.password = "test123"
    assert_equal Account.hash_password("test123"), newbie.password
    assert newbie.check_password("test123")
    assert !newbie.check_password("notcorrect")
  end
end
