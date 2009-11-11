require File.dirname(__FILE__) + '/../test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  fixtures :accounts
  fixtures :email_addresses

  def test_set_primary
    sec = email_addresses(:joe_secondary)
    sec.primary = true
    sec.save
    pri = email_addresses(:joe_primary)
    assert !pri.primary
  end
end
