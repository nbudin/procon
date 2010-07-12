module ActionView
  module Helpers
    module FormHelper
      def constrained_date_select(object_name, method, start_time, end_time, options = {}, html_options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_constrained_date_select_tag(start_time, end_time, options, html_options)
      end
      
      def constrained_datetime_select(object_name, method, start_time, end_time, options = {}, html_options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_constrained_datetime_select_tag(start_time, end_time, options, html_options)
      end
    end
    
    class FormBuilder
      %w{constrained_date_select constrained_datetime_select}.each do |selector|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{selector}(method, start_time, end_time, options = {})
            @template.send(
              #{selector.inspect},
              @object_name,
              method,
              start_time,
              end_time,
              objectify_options(options))
          end
        RUBY_EVAL
      end
    end
    
    class InstanceTag
      def to_constrained_date_select_tag(start_time, end_time, options = {}, html_options = {})
        with_constrained_datetime_wrapper(start_time, end_time, to_date_select_tag(options, html_options))
      end
      
      def to_constrained_datetime_select_tag(start_time, end_time, options = {}, html_options = {})
        with_constrained_datetime_wrapper(start_time, end_time, to_datetime_select_tag(options, html_options))
      end
      
      private
      def with_constrained_datetime_wrapper(start_time, end_time, content)
        content_tag(:span, :id => tag_id) do
          content + %{
            <script type="text/javascript">
            jQuery('##{tag_id}').constrainedDateTimeSelect(#{start_time.to_i}, #{end_time.to_i});
            </script>
          }.html_safe
        end
      end
    end
  end
end
