module Tick
  
  DATE_FORMAT = "yyyy-MM-dd"
  DATETIME_FORMAT = "EE, dd MMM yyyy HH:mm:ss ZZZ"
  
  class << self
    
    def log_in(company, email, password, &block)
      params = {
        company: company,
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
    
    def self.current_session
      Tick::Session.current
    end
    
  private
  
    def self.date_from_string(string)
      dateFormatter = NSDateFormatter.new
      dateFormatter.setDateFormat(Tick::DATE_FORMAT)
      dateFormatter.dateFromString(string)
    end
    
    def self.datetime_from_string(string)
      dateFormatter = NSDateFormatter.new
      dateFormatter.setDateFormat(Tick::DATETIME_FORMAT)
      dateFormatter.dateFromString(string)
    end
  
    def self.request_manager
      manager = AFHTTPRequestOperationManager.manager
      
      request_serializer = AFHTTPRequestSerializer.serializer
      request_serializer.setValue("application/xml", forHTTPHeaderField:"Content-type")
      manager.requestSerializer = request_serializer
      
      response_serializer = AFHTTPResponseSerializer.serializer
      response_serializer.acceptableContentTypes = NSSet.setWithObjects("application/xml", nil)
      manager.responseSerializer = response_serializer
      
      manager
    end
    
  end
  
end