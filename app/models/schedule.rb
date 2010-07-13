class Schedule < ActiveRecord::Base
  has_many :tracks, :order => :position
  belongs_to :event

  def events
    Event.in_schedule(self)
  end

  def all_events_registration_open=(status)
    events.each do |event|
      event.registration_open = status
      event.save
    end
  end
  
  def blocks_for_events(events)
    high_water_mark = nil
    blocks = []
    current_block_events = []
    
    events.each do |event|
      next unless event.start and event.end
      
      high_water_mark ||= event.end

      if high_water_mark < (event.start - 3.hours)
        unless current_block_events.empty?
          blocks << ScheduleBlock.new(self, current_block_events)
          current_block_events = []
        end
      end

      current_block_events << event
      high_water_mark = event.end if high_water_mark < event.end
    end
    
    blocks << ScheduleBlock.new(self, current_block_events) unless current_block_events.empty?
    
    return blocks
  end
  
  def blocks(options = {})
    rel = events.time_ordered
    rel = rel.for_registration if options[:for_registration]
    
    @blocks ||= blocks_for_events(rel.all)
  end
end
