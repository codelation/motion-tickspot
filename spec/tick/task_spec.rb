RackMotion.use TickTaskStub

describe "Tick::Task" do
  
  before do
    Tick::AuthenticationController.instance.company  = "company"
    Tick::AuthenticationController.instance.email    = "email"
    Tick::AuthenticationController.instance.password = "password"
  end
  
  it "should be defined" do
    Tick::Task.is_a?(Class).should.equal true
  end
  
  it "Tick::Task#list should return an array of all tasks for the given project" do
    @tasks = []
    Tick::Task.list(project_id: 2) do |tasks|
      @tasks = tasks
      resume
    end
    
    wait do
      @tasks.is_a?(Array).should.equal true
      @tasks.length.should.equal 1
    end
  end
  
  it "should have an id" do
    @task = @tasks.first
    @task.id.should.equal 14
  end
  
  it "should have a name" do
    @task.name.should.equal "Remove converter assembly"
  end
  
  it "should have a position" do
    @task.position.should.equal 1
  end
  
  it "should have a project id" do
    @task.project_id.should.equal 2
  end
  
  it "should have opened on and closed on dates" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd")
    @task.opened_on.should.equal dateFormatter.dateFromString("2006-01-01")
    @task.closed_on.should.equal nil
  end
  
  it "should have a budget" do
    @task.budget.should.equal 50.0
  end
  
  it "should have a billable attribute" do
    @task.billable.should.equal true
  end
  
  it "should have the sum of hours" do
    @task.sum_hours.should.equal 22.5
  end
  
  it "should have a users count" do
    @task.user_count.should.equal 2
  end
  
end