module Tick

  DATE_FORMAT = "yyyy-MM-dd"
  DATETIME_FORMAT = "EE, dd MMM yyyy HH:mm:ss ZZZ"

  class << self

    def log_in(company, email, password, &block)
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

    def self.api_name
      self.to_s.split('::').last.downcase
    end

    def self.api_path
      "/api/#{api_name}s"
    end

    def self.list(options={}, &block)

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

    def self.authentication_params
      {
        email: current_session.email,
        password: current_session.password
      }
    end

    def self.current_session
      if Session.current
        Session.current
      else
        raise AuthenticationError.new("User is not logged in.")
      end
    end

    def self.request_manager
      AFNetworkActivityLogger.sharedLogger.startLogging
      AFNetworkActivityLogger.sharedLogger.setLevel(AFLoggerLevelDebug)

      manager = AFHTTPRequestOperationManager.manager
      manager.requestSerializer = AFJSONRequestSerializer.serializer
      manager.requestSerializer.setValue("Timer for Tick (brian@codelation.com)", forHTTPHeaderField: "User-Agent")
      manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      manager
    end

  end

end
