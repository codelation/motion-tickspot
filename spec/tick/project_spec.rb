RackMotion.use TickProjectStub

describe "Tick::Project" do
  
  before do
    Tick::Session.current.company  = "company"
    Tick::Session.current.email    = "email"
    Tick::Session.current.password = "password"
  end
  
  it "should be defined" do
    Tick::Project.is_a?(Class).should.equal true
  end
  
  it "Tick::Project#list should return an array of all projects" do
    @projects = []
    Tick::Project.list do |projects|
      @projects = projects
      resume
    end
    
    wait do
      @projects.is_a?(Array).should.equal true
      @projects.length.should.equal 1
    end
  end
  
  it "should have an id" do
    @project = @projects.first
    @project.id.should.equal 7
  end
  
  it "should have a name" do
    @project.name.should.equal "Realign dilithium crystals"
  end
  
  it "should have a budget" do
    @project.budget.should.equal 50.0
  end
  
  it "should have a client id" do
    @project.client_id.should.equal 4
  end
  
  it "should have an owner id" do
    @project.owner_id.should.equal 14
  end
  
  it "should have opened on and closed on dates" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd")
    @project.opened_on.should.equal dateFormatter.dateFromString("2006-01-01")
    @project.closed_on.should.equal nil
  end
  
  it "should have created and updated at dates" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("EE, dd MM yyyy hh:mm:ss zzz")
    date = dateFormatter.dateFromString("Tue, 07 Oct 2008 14:46:16 -0400")
    @project.created_at.should.equal date
    @project.updated_at.should.equal date
  end
  
  it "should have the client name" do
    @project.client_name.should.equal "Starfleet Command"
  end
  
  it "should have the sum of hours" do
    @project.sum_hours.should.equal 22.5
  end
  
  it "should have a users count" do
    @project.user_count.should.equal 2
  end
  
  it "should have an array of tasks" do
    @project.tasks.is_a?(Array).should.equal true
    @project.tasks.length.should.equal 1
    @project.tasks.first.is_a?(Tick::Task).should.equal true
  end
  
end