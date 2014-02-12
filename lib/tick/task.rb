module Tick
  
  class Task < Tick::Base
    attr_accessor :billable, :budget, :closed_on, :name, :opened_on, 
                  :position, :project_id, :sum_hours, :user_count
                  
    XML_PROPERTIES = %w( id billable budget closed_on name 
                         opened_on position project_id sum_hours user_count )
                  
    def self.list(options={}, &block)
      url = "https://#{current_session.company}.tickspot.com/api/tasks"

      params = {
        email: current_session.email,
        password: current_session.password
      }.merge!(options)

      request_manager.GET(url, parameters:params, success:lambda{|operation, result|
        tasks = []
        
        # Parse XML
        error = Pointer.new(:object)
        xml = GDataXMLDocument.alloc.initWithXMLString(result.to_s, error:error)
        
        # Create the task objects
        error = Pointer.new(:object)
        task_nodes = xml.nodesForXPath("//task", error:error)

        task_nodes.each do |task_node|
          task = new
          task.set_properties_from_xml_node(task_node, XML_PROPERTIES)
          tasks << task
        end

        block.call(tasks) if block
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error) if block
      })

      self
    end
    
  end
  
end