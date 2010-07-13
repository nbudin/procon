module ActionView
  module Helpers
    module FormHelper
      %w{date time datetime}.each do |selector|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def constrained_#{selector}_select(object_name, method, start_time, end_time, options = {}, html_options = {})
            InstanceTag.new(object_name, method, self, options.delete(:object)).to_constrained_#{selector}_select_tag(start_time, end_time, options, html_options)
          end
        RUBY_EVAL
      end
    end
    
    class FormBuilder
      %w{date time datetime}.each do |selector|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def constrained_#{selector}_select(method, start_time, end_time, options = {}, html_options={})
            @template.send(
              "constrained_#{selector}_select",
              @object_name,
              method,
              start_time,
              end_time,
              objectify_options(options),
              html_options)
          end
        RUBY_EVAL
      end
    end
    
    class InstanceTag
      %w{date time datetime}.each do |selector|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def to_constrained_#{selector}_select_tag(start_time, end_time, options = {}, html_options = {})
            with_constrained_datetime_wrapper(start_time, end_time, to_#{selector}_select_tag(options, html_options))
          end
        RUBY_EVAL
      end
      
      private
      def with_constrained_datetime_wrapper(start_time, end_time, content)
        content_tag(:span, content, :id => tag_id, :class => "constrained_datetime_select")
      end
    end
  end
end
