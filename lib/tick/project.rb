module Tick

  class Project < Tick::Base
    attr_accessor :billable, :budget, :client_id, :date_closed,
                  :name, :notifications, :owner_id, :recurring,
                  :tasks, :url

    JSON_ATTRIBUTES = %w( id billable budget client_id created_at date_closed
                          name notifications owner_id recurring updated_at url )

    def date_closed=(value)
      value = date_from_string(value) if value.is_a?(String)
      super(value)
    end
  end
end
