module Tick
  
  class Project < Tick::Base
    attr_accessor :budget, :client_id, :client_name, :closed_on,
                  :name, :opened_on, :owner_id, :sum_hours, :tasks,
                  :user_count
                  
    XML_PROPERTIES = %w( id budget client_id client_name closed_on created_at 
                         name opened_on owner_id sum_hours updated_at user_count )
    
    def self.list(options={}, &block)
      url = "https://#{current_session.company}.tickspot.com/api/projects"
      
      params = authentication_params.merge!(options)
      
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
          project.set_properties_from_xml_node(project_node)
          project.tasks = get_tasks_from_xml_node(project_node)
          project.tasks.each do |task|
            task.project = project
          end
          projects << project
        end
        
        block.call(projects) if block
      }, failure:lambda{|operation, error|
        block.call(error) if block
      })
      
      self
    end
    
  private
    
    def self.get_tasks_from_xml_node(xml_node)
      tasks = []
      
      # Seems to be mixed results when parsing the XML where
      # sometimes the tasks element doesn't exist
      tasks_elements = xml_node.elementsForName("tasks")
      if tasks_elements
        task_nodes = tasks_elements.first.elementsForName("task")
      else
        task_nodes = xml_node.elementsForName("task")
      end
      
      task_nodes.each do |task_node|
        task = Task.new
        task.set_properties_from_xml_node(task_node)
        tasks << task
      end
      
      tasks
    end
    
  end
  
end