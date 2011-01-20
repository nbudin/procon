class ScheduleBlock
  attr_reader :schedule, :events

  def initialize(schedule, events)
    @schedule = schedule
    @events = events
  end
  
  def start
    @start ||= events.collect(&:start).compact.min
  end
  
  def end
    @end ||= events.collect(&:end).compact.max
  end
  
  def tracks
    @tracks ||= schedule.tracks.all(:include => :events).select { |t| events.any? { |e| t.event_ids.include?(e.id) } }
  end
  
  def min_event_length
    @min_event_length ||= events.collect(&:length).reject { |l| l <= 0 }.compact.min
  end
  
  def interval
    @interval ||= begin
      interval = 30.minutes
      min_length = self.min_event_length
    
      # get more granular if we need to
      while min_length < (interval * 4) and interval > 1.minute do
        interval /= 2
      end
    
      # get less granular if we need to
      while min_length > (interval * 8) do
        interval *= 2
      end
    
      interval
    end    
  end
  
  def event_positions_for_events(events)
    schedlen = self.end - self.start
    event_positions = {}

    # structure of grabbed_columns:
    # grabbed_columns[track][subcol] = end_time
    grabbed_columns = {}
    pregrabs = {}
    tracks.each do |track|
      grabbed_columns[track] = {}
    end

    numcols = tracks.size
    colsize = ((100.0 - 10.0) / numcols)
    now = self.start
      
    while now < self.end
      nowevents = []
      while events.size > 0 and events[0].start < (now + interval)
        nowevents.push(events.shift)
      end
    
      colnum = 0
      tracks.each do |track|
        # check for expired column grabs
        grabbed_columns[track].reject! { |col, time| time <= now }
      
        trackevents = nowevents.select {|e| track.event_ids.include? e.id }
        eventnum = 0
      
        # pre-grab columns for upcoming events
        trackevents.each do |event|
          events.each do |e|
            if not pregrabs.has_key? e.id
              if track.event_ids.include?(e.id) and e.start > event.start and e.start < event.end
                pgcolnum = eventnum + 1
                while grabbed_columns[track].has_key?(pgcolnum)
                  pgcolnum += 1
                end
                grabbed_columns[track][pgcolnum] = e.start
                pregrabs[e.id] = true
              end
            end
          end
        end
      
        # calculate visual dimensions for each event
        eventsize = (colsize - 0.5) / (trackevents.size + grabbed_columns[track].size)          
        trackevents.each do |event|
          next if event_positions[event]
          
          while grabbed_columns[track].has_key?(eventnum)
            eventnum += 1
          end
          
          trackcount = tracks.select do |t|
            t.event_ids.include? event.id
          end.size
          
          pos = ScheduledEventPosition.new(self, event)
          pos.left = (colsize * colnum) + (eventsize * eventnum) + 10.0
          pos.width = trackcount > 1 ? trackcount * colsize : eventsize
          pos.top = ((event.start - self.start) / schedlen) * 100.0
          pos.height = ((event.end - event.start) / schedlen) * 100.0
          pos.color = trackcount > 1 ? '#ffc' : track.color
          event_positions[event] = pos
        
          grabbed_columns[track][eventnum] = event.end
          eventnum += 1
        end
      
        colnum += 1
      end
    
      now += self.interval
    end
    
    event_positions
  end
  
  def event_positions
    @event_positions ||= event_positions_for_events(events)
    @event_positions.values
  end
end
