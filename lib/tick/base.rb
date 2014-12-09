module Tick

  DATE_FORMAT = "yyyy-MM-dd"
  DATETIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"

  class << self

    def log_in(email, password, &block)
      params = {
        email: email,
        password: password
      }
      Session.create(params) do |session|
        block.call(session) if block
      end
    end
    alias_method :login, :log_in

    def log_out
      Session.current.destroy if Session.current
    end
    alias_method :logout, :log_out

    def logged_in?
      Session.logged_in?
    end

  end

  class Base
    attr_accessor :id, :created_at, :updated_at
    attr_reader :api_name, :api_path

    def created_at=(value)
      value = datetime_from_string(value) if value.is_a?(String)
      super(value)
    end

    def set_attributes_from_json(json)
      self.class::JSON_ATTRIBUTES.each do |attribute|
        value = json[attribute]
        self.send("#{attribute}=", value)
      end
    end

    def updated_at=(value)
      value = datetime_from_string(value) if value.is_a?(String)
      super(value)
    end

    def self.api_name
      self.to_s.split('::').last.downcase
    end

    def self.api_path
      api_path = "/api/v2/#{api_name}s"

      if current_session.subscription_id
        api_path = "/#{current_session.subscription_id}#{api_path}"
      end

      api_path
    end

    def self.list(options={}, &block)
      url = "https://www.tickspot.com#{api_path}.json"

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

  private

    def date_from_string(string)
      dateFormatter = NSDateFormatter.new
      dateFormatter.setDateFormat(DATE_FORMAT)
      dateFormatter.dateFromString(string)
    end

    def datetime_from_string(string)
      dateFormatter = NSDateFormatter.new
      dateFormatter.setDateFormat(DATETIME_FORMAT)
      dateFormatter.dateFromString(string)
    end

    def self.current_session
      if Session.current
        Session.current
      else
        raise AuthenticationError.new("User is not logged in.")
      end
    end

    def self.request_manager
      manager = AFHTTPRequestOperationManager.manager
      manager.requestSerializer = AFJSONRequestSerializer.serializer
      manager.requestSerializer.setValue("Timer for Tick (brian@codelation.com)", forHTTPHeaderField: "User-Agent")
      manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

      # Determine whether the API token or email/password should be used for authentication
      if Session.current && Session.current.api_token
        manager.requestSerializer.setValue("Token token=#{Session.current.api_token}", forHTTPHeaderField: "Authorization")
      elsif Session.logged_in?
        manager.requestSerializer.setAuthorizationHeaderFieldWithUsername(Session.current.email, password: Session.current.password)
      end

      manager
    end

  end

end
