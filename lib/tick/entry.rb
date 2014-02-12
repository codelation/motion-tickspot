module Tick
  
  class Entry < Tick::Base
    attr_accessor :billable, :billed, :budget, :client_name,
                  :date, :hours, :notes, :project_name, :sum_hours, 
                  :task_id, :task_name, :user_email, :user_id
                  
    XML_PROPERTIES = %w( id billable billed budget client_name created_at date hours notes
                         project_name sum_hours task_id task_name updated_at user_email user_id )
                         
    def self.create(options={}, &block)
      url  = "https://#{current_session.company}.tickspot.com/api/create_entry"
      
      params = {
        email: current_session.email,
        password: current_session.password
      }.merge!(options)
      
      if params[:date].is_a?(NSDate)
        dateFormatter = NSDateFormatter.new
        dateFormatter.setDateFormat(Tick::DATE_FORMAT)
        params[:date] = dateFormatter.stringFromDate(params[:date])
      end
      
      request_manager.GET(url, parameters:params, success:lambda{|operation, result|
        error = Pointer.new(:object)
        xml = GDataXMLDocument.alloc.initWithXMLString(result.to_s, error:error)
        
        # Create the entry object from xml
        error = Pointer.new(:object)
        entry_node = xml.nodesForXPath("//entry", error:error).first
        entry = new
        entry.set_properties_from_xml_node(entry_node, XML_PROPERTIES)
        block.call(entry) if block
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error) if block
      })
      
      self
    end
    
    def self.list(options={}, &block)
      url = "https://#{current_session.company}.tickspot.com/api/entries"

      params = {
        email: current_session.email,
        password: current_session.password
      }.merge!(options)

      request_manager.GET(url, parameters:params, success:lambda{|operation, result|
        entries = []
        
        # Parse XML
        error = Pointer.new(:object)
        xml = GDataXMLDocument.alloc.initWithXMLString(result.to_s, error:error)
        
        # Create the entry objects
        error = Pointer.new(:object)
        entry_nodes = xml.nodesForXPath("//entry", error:error)

        entry_nodes.each do |entry_node|
          entry = new
          entry.set_properties_from_xml_node(entry_node, XML_PROPERTIES)
          entries << entry
        end

        block.call(entries) if block
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error) if block
      })

      self
    end
    
  end
  
end