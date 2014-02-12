module Tick
  
  class Client < Tick::Base
    attr_accessor :name
    
    XML_PROPERTIES = %w( id name )
    
    def self.list(options={}, &block)
      url = "https://#{current_session.company}.tickspot.com/api/clients"
      
      params = {
        email: current_session.email,
        password: current_session.password
      }.merge!(options)
      
      request_manager.GET(url, parameters:params, success:lambda{|operation, result|
        clients = []
        
        # Parse XML
        error = Pointer.new(:object)
        xml = GDataXMLDocument.alloc.initWithXMLString(result.to_s, error:error)
        
        # Create the client objects
        error = Pointer.new(:object)
        client_nodes = xml.nodesForXPath("//client", error:error)
        
        client_nodes.each do |client_node|
          client = new
          client.set_properties_from_xml_node(client_node, XML_PROPERTIES)
          clients << client
        end
        
        block.call(clients) if block
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error) if block
      })
      
      self
    end
    
  end
  
end