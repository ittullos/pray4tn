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
      attributes['created_at'] = attributes['created_at'].utc.iso8601(3)
      attributes['updated_at'] = attributes['updated_at'].utc.iso8601(3)
    end
  end

  def data_objects_for_multiple(entities)
    entities.map { |entity| data_object_for(entity) }
  end
end
