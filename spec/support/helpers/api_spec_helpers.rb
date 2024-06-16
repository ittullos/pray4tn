# frozen_string_literal: true

module ApiSpecHelpers
  def parsed_response
    unless last_response
      raise 'a request must be made before the response can be parsed'
    end

    JSON.parse(last_response.body)
  end

  def data_object_for(entity)
    entity.attributes.tap do |attributes|
      convert_timestamps(attributes)
    end
  end

  def data_objects_for_multiple(entities)
    entities.map { |entity| data_object_for(entity) }
  end

  def convert_timestamps(attributes)
    attributes.each do |key, value|
      if value.kind_of?(Time)
        attributes[key] = value.utc.iso8601(3)
      end
    end
  end
end
