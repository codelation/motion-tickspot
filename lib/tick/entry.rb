module Tick
  
  class Entry < Tick::Base
    attr_accessor :billable, :billed, :budget, :client_name,
                  :date, :hours, :notes, :project_name, :sum_hours, 
                  :task_id, :task_name, :user_email, :user_id
    
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
        # TODO: Return Tick::Entry object
        block.call(xml)
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error)
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
          entry.id           = entry_node.elementsForName("id").first.stringValue.intValue
          entry.billable     = entry_node.elementsForName("billable").first.stringValue.boolValue
          entry.billed       = entry_node.elementsForName("billed").first.stringValue.boolValue
          entry.budget       = entry_node.elementsForName("budget").first.stringValue.floatValue
          entry.client_name  = entry_node.elementsForName("client_name").first.stringValue
          entry.created_at   = datetime_from_string(entry_node.elementsForName("created_at").first.stringValue)
          entry.date         = date_from_string(entry_node.elementsForName("date").first.stringValue)
          entry.hours        = entry_node.elementsForName("hours").first.stringValue.floatValue
          entry.notes        = entry_node.elementsForName("notes").first.stringValue
          entry.project_name = entry_node.elementsForName("project_name").first.stringValue
          entry.sum_hours    = entry_node.elementsForName("sum_hours").first.stringValue.floatValue
          entry.task_id      = entry_node.elementsForName("task_id").first.stringValue.intValue
          entry.task_name    = entry_node.elementsForName("task_name").first.stringValue
          entry.updated_at   = datetime_from_string(entry_node.elementsForName("updated_at").first.stringValue)
          entry.user_email   = entry_node.elementsForName("user_email").first.stringValue
          entry.user_id      = entry_node.elementsForName("user_id").first.stringValue.intValue
          
          entries << entry
        end

        block.call(entries)
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error)
      })

      self
    end
    
  end
  
end