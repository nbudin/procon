class ScheduledEventPosition
  attr_reader :schedule_block, :event
  attr_accessor :width, :height, :left, :top, :color
  
  def initialize(schedule_block, event)
    @schedule_block = schedule_block
    @event = event
  end
end
