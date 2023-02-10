# frozen_string_literal: true

module Aws
  module Record

    # @api private
    class ModelAttributes
      attr_reader :attributes, :storage_attributes

      def initialize(model_class)
        @model_class = model_class
        @attributes = {}
        @storage_attributes = {}
      end

      def register_attribute(name, marshaler, opts)
        attribute = Attribute.new(name, opts.merge(marshaler: marshaler))
        _new_attr_validation(name, attribute)
        @attributes[name] = attribute
        @storage_attributes[attribute.database_name] = name
        attribute
      end

      def register_superclass_attribute (name, attribute)
        _new_attr_validation(name, attribute)
        @attributes[name] = attribute.dup
        @storage_attributes[attribute.database_name] = name
        attribute
      end

      def attribute_for(name)
        @attributes[name]
      end

      def storage_name_for(name)
        attribute_for(name).database_name
      end

      def present?(name)
        attribute_for(name) ? true : false
      end

      def db_to_attribute_name(storage_name)
        @storage_attributes[storage_name]
      end

      private
      def _new_attr_validation(name, attribute)
        _validate_attr_name(name)
        _check_for_naming_collisions(name, attribute.database_name)
        _check_if_reserved(name)
      end

      def _validate_attr_name(name)
        unless name.is_a?(Symbol)
          raise ArgumentError.new("Must use symbolized :name attribute.")
        end
        if @attributes[name]
          raise Errors::NameCollision.new(
            "Cannot overwrite existing attribute #{name}"
          )
        end
      end

      def _check_if_reserved(name)
        if @model_class.instance_methods.include?(name)
          raise Errors::ReservedName.new(
            "Cannot name an attribute #{name}, that would collide with an"\
              " existing instance method."
          )
        end
      end

      def _check_for_naming_collisions(name, storage_name)
        if @attributes[storage_name.to_sym]
          raise Errors::NameCollision.new(
            "Custom storage name #{storage_name} already exists as an"\
              " attribute name in #{@attributes}"
          )
        elsif @storage_attributes[name.to_s]
          raise Errors::NameCollision.new(
            "Attribute name #{name} already exists as a custom storage"\
              " name in #{@storage_attributes}"
          )
        elsif @storage_attributes[storage_name]
          raise Errors::NameCollision.new(
            "Custom storage name #{storage_name} already in use in"\
              " #{@storage_attributes}"
          )
        end
      end
    end

  end
end
