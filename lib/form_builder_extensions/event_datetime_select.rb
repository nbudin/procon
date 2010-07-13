module ActionView
  module Helpers
    class FormBuilder
      %w{date time datetime}.each do |selector|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def event_#{selector}_select(method, options={}, html_options={})
            constrained_#{selector}_select(method, object.parent.try(:start), object.parent.try(:end), eventify_options(options), html_options)
          end
        RUBY_EVAL
      end
    
      private
      def eventify_options(options)
        event_options = options.dup
      
        event_options[:minute_step] = 15 unless event_options.has_key?(:minute_step)
        event_options[:datetime_separator] = " at " unless event_options.has_key?(:datetime_separator)
        event_options
      end
    end
  end
end
    