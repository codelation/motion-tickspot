RackMotion.use TickTaskStub

describe "Tick::Task" do

  before do
    session = Tick::Session.new
    session.email           = "email"
    session.password        = "password"
    session.api_token       = "f67158e7bf3d7a0fcaf9d258ace8b468"
    session.subscription_id = 15
    Tick::Session.instance_variable_set("@current", session)
  end

  it "should be defined" do
    Tick::Task.is_a?(Class).should.equal true
  end

  it "Tick::Task#list should return an array of all tasks for the given project" do
    @tasks = []
    Tick::Task.list(project_id: 16) do |tasks|
      @tasks = tasks
      resume
    end

    wait do
      @tasks.is_a?(Array).should.equal true
      @tasks.length.should.equal 2
    end
  end

  it "should have an id" do
    @task = @tasks.first
    @task.id.should.equal 25
  end

  it "should have a name" do
    @task.name.should.equal "Install exhaust port"
  end

  it "should have a position" do
    @task.position.should.equal 1
  end

  it "should have a project id" do
    @task.project_id.should.equal 16
  end

  it "should have date closed" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd")
    @task.date_closed.should.equal dateFormatter.dateFromString("2014-09-10")
  end

  it "should have a billable attribute" do
    @task.billable.should.equal true
  end

  it "should have a budget" do
    @task.budget.round(1).should.equal 14.0
  end

  it "should have a url" do
    @task.url.should.equal "https://www.tickspot.com/api/v2/123/tasks/28.json"
  end

  it "should have created and updated at dates" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZZZ")
    date = dateFormatter.dateFromString("2014-09-18T15:03:18.000-04:00")
    @task.created_at.should.equal date
    @task.updated_at.should.equal date
  end

end
