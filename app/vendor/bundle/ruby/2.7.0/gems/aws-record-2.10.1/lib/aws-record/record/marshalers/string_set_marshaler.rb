# frozen_string_literal: true

module Aws
  module Record
    module Marshalers

      class StringSetMarshaler
        def initialize(opts = {})
        end

        def type_cast(raw_value)
          case raw_value
          when nil
            Set.new
          when ''
            Set.new
          when Set
            _as_strings(raw_value)
          else
            if raw_value.respond_to?(:to_set)
              _as_strings(raw_value.to_set)
            else
              msg = "Don't know how to make #{raw_value} of type"\
                " #{raw_value.class} into a String Set!"
              raise ArgumentError, msg
            end
          end
        end

        def serialize(raw_value)
          set = type_cast(raw_value)
          if set.is_a?(Set)
            if set.empty?
              nil
            else
              set
            end
          else
            msg = "expected a Set value or nil, got #{set.class}"
            raise ArgumentError, msg
          end
        end

        private
        def _as_strings(set)
          set.collect! do |item|
            if item.is_a?(String)
              item
            else
              item.to_s
            end
          end
        end
      end

    end
  end
end
