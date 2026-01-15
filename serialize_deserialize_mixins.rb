# frozen_string_literal: true

require 'json'

# This is a mixins  of serialize and deserialize
module BasicSerializable
  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.each do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse(string)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
  end
end
