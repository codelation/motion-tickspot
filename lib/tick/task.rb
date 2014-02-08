module Tick
  
  class Task < Tick::Base    
    attr_accessor :billable, :budget, :closed_on, :name, :opened_on, 
                  :position, :project_id, :sum_hours, :user_count
                  
    def self.list(options={}, &block)
      url = "https://#{authentication_controller.company}.tickspot.com/api/tasks"

      params = {
        email: authentication_controller.email,
        password: authentication_controller.password
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
          task.id         = task_node.elementsForName("id").first.stringValue.intValue
          task.billable   = task_node.elementsForName("billable").first.stringValue.boolValue
          task.budget     = task_node.elementsForName("budget").first.stringValue.floatValue
          task.closed_on  = date_from_string(task_node.elementsForName("closed_on").first.stringValue)
          task.name       = task_node.elementsForName("name").first.stringValue
          task.opened_on  = date_from_string(task_node.elementsForName("opened_on").first.stringValue)
          task.position   = task_node.elementsForName("position").first.stringValue.intValue
          task.project_id = task_node.elementsForName("project_id").first.stringValue.intValue
          task.sum_hours  = task_node.elementsForName("sum_hours").first.stringValue.floatValue
          task.user_count = task_node.elementsForName("user_count").first.stringValue.intValue
          tasks << task
        end

        block.call(tasks)
      }, failure:lambda{|operation, error|
        authentication_controller.logout
        block.call(error)
      })

      self
    end
    
  end
  
end