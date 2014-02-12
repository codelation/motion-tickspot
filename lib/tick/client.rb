module Tick
  
  class Client < Tick::Base
    attr_accessor :name
    XML_PROPERTIES = %w( id name )
  end
  
end