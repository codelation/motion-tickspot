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
    attr_reader :api_name, :api_path
    
    def set_properties_from_xml_node(xml_node)
      self.class::XML_PROPERTIES.each do |property|
        xml_elements = xml_node.elementsForName(property)
        value = xml_elements ? get_xml_element_value(xml_elements.first) : nil
        self.send("#{property}=", value)
      end
    end
    
    def self.api_name
      self.to_s.split('::').last.downcase
    end
    
    def self.api_path
      "/api/#{api_name}s"
    end
    
    def self.list(options={}, &block)
      url = "https://#{current_session.company}.tickspot.com#{api_path}"
      
      params = authentication_params.merge!(options)
      
      request_manager.GET(url, parameters:params, success:lambda{|operation, result|
        objects = []
        
        # Parse XML
        error = Pointer.new(:object)
        xml = GDataXMLDocument.alloc.initWithXMLString(result.to_s, error:error)
        
        # Create the objects
        error = Pointer.new(:object)
        xml_nodes = xml.nodesForXPath("//#{api_name}", error:error)
        
        xml_nodes.each do |xml_node|
          object = new
          object.set_properties_from_xml_node(xml_node)
          objects << object
        end
        
        block.call(objects) if block
      }, failure:lambda{|operation, error|
        block.call(error) if block
      })
      
      self
    end
    
  private
  
    def get_xml_element_value(xml_element)
      type = xml_element.attributeForName("type")
      type = type.stringValue if type
      case type
      when "boolean"
        xml_element.stringValue.boolValue
      when "date"
        date_from_string(xml_element.stringValue)
      when "datetime"
        datetime_from_string(xml_element.stringValue)
      when "float"
        xml_element.stringValue.floatValue
      when "integer"
        xml_element.stringValue.intValue
      else
        value = xml_element.stringValue
        if value == "true"
          true
        elsif value == "false"
          false
        else
          value
        end
      end
    end
    
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