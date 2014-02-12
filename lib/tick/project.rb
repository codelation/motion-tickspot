module Tick
  
  class Project < Tick::Base
    attr_accessor :budget, :client_id, :client_name, :closed_on,
                  :name, :opened_on, :owner_id, :sum_hours, :tasks,
                  :user_count
                  
    XML_PROPERTIES = %w( id budget client_id client_name closed_on created_at 
                         name opened_on owner_id sum_hours updated_at user_count )
    
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
          project.set_properties_from_xml_node(project_node, XML_PROPERTIES)
          
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
        
        block.call(projects) if block
      }, failure:lambda{|operation, error|
        current_session.destroy
        block.call(error) if block
      })
      
      self
    end
    
  end
  
end