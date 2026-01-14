# frozen_string_literal: true

require 'json'

# This is a mixins  of serialize and deserialize
module BasicSerializable
  @@serializer = JSON
  def serialize
  end

  def unserialize(string)
  end
end
