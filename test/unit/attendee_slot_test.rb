require 'test_helper'

class AttendeeSlotTest < ActiveSupport::TestCase
  def test_nil_defaults_to_zero
    slot = AttendeeSlot.new(:max => nil, :min => nil, :preferred => nil)
    assert_equal 0, slot.min
    assert_equal 0, slot.max
    assert_equal 0, slot.preferred
  end
end
