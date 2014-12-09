module Tick

  class Task < Tick::Base
    attr_accessor :billable, :budget, :date_closed, :name,
                  :position, :project, :project_id, :url

    JSON_ATTRIBUTES = %w( id billable budget created_at date_closed name position project_id updated_at url )

    def date_closed=(value)
      value = date_from_string(value) if value.is_a?(String)
      super(value)
    end

    def self.list(options={}, &block)
      if options[:project_id]
        url  = "https://www.tickspot.com/#{current_session.subscription_id}/api/v2"
        url += "/projects/#{options[:project_id]}/tasks.json"
      else
        url = "https://www.tickspot.com#{api_path}.json"
      end

      request_manager.GET(url, parameters: options, success: ->(operation, results) {
        objects = []

        results.each do |result|
          object = new
          object.set_attributes_from_json(result)
          objects << object
        end

        block.call(objects) if block
      }, failure: ->(operation, error) {
        block.call(error) if block
      })

      self
    end
  end

end
