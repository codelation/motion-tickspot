module Tick
  
  DATE_FORMAT = "yyyy-MM-dd"
  DATETIME_FORMAT = "EE, dd MM yyyy hh:mm:ss zzz"
  
  class Base
    attr_accessor :id, :created_at, :updated_at
    
    def self.authentication_controller
      Tick::Session.current
    end
    
  private
  
    def self.date_from_string(string)
      dateFormatter = NSDateFormatter.new
      dateFormatter.setDateFormat(Tick::DATE_FORMAT)
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