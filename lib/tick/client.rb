module Tick

  class Client < Tick::Base
    attr_accessor :name
    JSON_ATTRIBUTES = %w( id name )
  end

end
