module Tick
  
  class Client < Tick::Base
    attr_accessor :name
    
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
          client.id = client_node.elementsForName("id").first.stringValue.intValue
          client.name = client_node.elementsForName("name").first.stringValue
          
          clients << client
        end
        
        block.call(clients)
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error)
      })
      
      self
    end
    
  end
  
end