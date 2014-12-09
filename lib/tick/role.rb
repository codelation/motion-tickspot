module Tick

  class Role < Tick::Base
    attr_accessor :api_token, :company, :subscription_id
    JSON_ATTRIBUTES = %w( api_token company subscription_id )
  end

end
