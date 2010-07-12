module ActionView
  module Helpers
    module FormHelper
      def person_field(object_name, method, options = {})
        text_field(object_name, method, options)
      end
    end
    
    class FormBuilder
      def person_field(method, options = {})
        @template.send("person_field", @object_name, method, objectify_options(options))
      end
    end
  end
end