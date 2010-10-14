module DateTimeExtensions
  module ConferenceDays
    # The idea of a conference day is that it delineates the dividing line between events 
    # one would stay up late for, and events one would get up early for.
    #
    # Conference days begin at 5:00 AM.  Why 5:00?  It feels right.
    
    def beginning_of_conference_day
      if hour < 5
        self - 1.day
      else
        self
      end.change(:hour => 5)
    end
    
    def end_of_conference_day
      if hour > 5
        self + 1.day
      else
        self
      end.change(:hour => 5)
    end
  end
end

Time.send(:include, DateTimeExtensions::ConferenceDays)
DateTime.send(:include, DateTimeExtensions::ConferenceDays)