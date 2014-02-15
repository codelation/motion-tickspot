module Tick
  
  class Task < Tick::Base
    attr_accessor :billable, :budget, :closed_on, :name, :opened_on, 
                  :position, :project, :project_id, :sum_hours, :user_count
                  
    XML_PROPERTIES = %w( id billable budget closed_on name 
                         opened_on position project_id sum_hours user_count )
  end
  
end