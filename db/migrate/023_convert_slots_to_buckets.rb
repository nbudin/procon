class ConvertSlotsToBuckets < ActiveRecord::Migration
  def self.up
    AttendeeSlot.find_all.each do |s|
      b = RegistrationBucket.new
      b.event = s.event
      b.min = s.min
      b.max = s.max
      b.preferred = s.preferred
      
      b.rule = GenderRule.create :gender => s.gender
      
      b.save
      s.destroy
    end
  end

  def self.down
    RegistrationBucket.find_all.each do |b|
      if b.rule.kind_of? GenderRule
        s = AttendeeSlot.new
        s.event = b.event
        s.min = b.min
        s.max = b.max
        s.preferred = b.preferred
      
        s.gender = b.rule.gender
        s.save
        b.destroy
      end
    end
  end
end
