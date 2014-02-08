module Tick
  
  class Project < Tick::Base
    attr_accessor :budget, :client_id, :client_name, :closed_on,
                  :name, :opened_on, :owner_id, :sum_hours, :tasks,
                  :user_count
    
    def self.list(options={}, &block)
      url = "https://#{current_session.company}.tickspot.com/api/projects"
      
      params = {
        email: current_session.email,
        password: current_session.password
      }.merge!(options)
      
      request_manager.GET(url, parameters:params, success:lambda{|operation, result|
        projects = []
        
        # Parse XML
        error = Pointer.new(:object)
        xml = GDataXMLDocument.alloc.initWithXMLString(result.to_s, error:error)
        
        # Create the project objects
        error = Pointer.new(:object)
        project_nodes = xml.nodesForXPath("//project", error:error)
        
        project_nodes.each do |project_node|
          project = new
          project.id          = project_node.elementsForName("id").first.stringValue.intValue
          project.budget      = project_node.elementsForName("budget").first.stringValue.floatValue
          project.client_id   = project_node.elementsForName("client_id").first.stringValue.intValue
          project.client_name = project_node.elementsForName("client_name").first.stringValue
          project.closed_on   = date_from_string(project_node.elementsForName("closed_on").first.stringValue)
          project.created_at  = datetime_from_string(project_node.elementsForName("created_at").first.stringValue)
          project.name        = project_node.elementsForName("name").first.stringValue
          project.opened_on   = date_from_string(project_node.elementsForName("opened_on").first.stringValue)
          project.owner_id    = project_node.elementsForName("owner_id").first.stringValue.intValue
          project.sum_hours   = project_node.elementsForName("sum_hours").first.stringValue.floatValue
          project.updated_at  = datetime_from_string(project_node.elementsForName("updated_at").first.stringValue)
          project.user_count  = project_node.elementsForName("user_count").first.stringValue.intValue
          
          project.tasks = []
          task_nodes = project_node.elementsForName("tasks").first.elementsForName("task")
          task_nodes.each do |task_node|
            task = Task.new
            task.id = task_node.elementsForName("id").first.stringValue.intValue
            task.name = task_node.elementsForName("name").first.stringValue
            project.tasks << task
          end
          
          projects << project
        end
        
        block.call(projects)
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error)
      })
      
      self
    end
    
  end
  
end