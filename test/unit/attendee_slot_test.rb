require 'test_helper'

class AttendeeSlotTest < ActiveSupport::TestCase
  def test_fields
    slot = AttendeeSlot.new(:max => 3, :min => 1, :preferred => 2)
    assert_equal 1, slot.min
    assert_equal 3, slot.max
    assert_equal 2, slot.preferred
  end

  def test_nil_defaults_to_zero
    slot = AttendeeSlot.new(:max => nil, :min => nil, :preferred => nil)
    assert_equal 0, slot.min
    assert_equal 0, slot.max
    assert_equal 0, slot.preferred
  end
end
