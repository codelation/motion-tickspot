module Tick

  class Entry < Tick::Base
    attr_accessor :date, :hours, :notes, :task_id, :user_id

    JSON_ATTRIBUTES = %w( id created_at date hours notes task_id user_id )

    def date=(value)
      value = date_from_string(value) if value.is_a?(String)
      super(value)
    end

    def self.api_path
      "/#{current_session.subscription_id}/api/v2/entries"
    end

    def self.create(options={}, &block)
      url = "https://www.tickspot.com#{api_path}.json"

      if options[:date].is_a?(NSDate)
        dateFormatter = NSDateFormatter.new
        dateFormatter.setDateFormat(DATE_FORMAT)
        options[:date] = dateFormatter.stringFromDate(options[:date])
      end

      request_manager.POST(url, parameters: options, success: ->(operation, result) {
        entry = new
        entry.set_attributes_from_json(result)

        block.call(entry) if block
      }, failure: ->(operation, error) {
        block.call(error) if block
      })

      self
    end
  end

end
