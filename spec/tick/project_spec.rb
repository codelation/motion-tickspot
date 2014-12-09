RackMotion.use TickProjectStub

describe "Tick::Project" do

  before do
    session = Tick::Session.new
    session.email           = "email"
    session.password        = "password"
    session.api_token       = "f67158e7bf3d7a0fcaf9d258ace8b468"
    session.subscription_id = 15
    Tick::Session.instance_variable_set("@current", session)
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
      @projects.length.should.equal 2
    end
  end

  it "should have an id" do
    @project = @projects.first
    @project.id.should.equal 16
  end

  it "should have a name" do
    @project.name.should.equal "Build Death Star"
  end

  it "should have a billable attribute" do
    @project.billable.should.equal true
  end

  it "should have a budget" do
    @project.budget.round(1).should.equal 150.0
  end

  it "should have a client id" do
    @project.client_id.should.equal 12
  end

  it "should have date closed" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd")
    @project.date_closed.should.equal dateFormatter.dateFromString("2014-09-10")
  end

  it "should have a notifications attribute" do
    @project.notifications.should.equal false
  end

  it "should have an owner id" do
    @project.owner_id.should.equal 3
  end

  it "should have a recurring attribute" do
    @project.recurring.should.equal false
  end

  it "should have a url" do
    @project.url.should.equal "https://www.tickspot.com/api/v2/123/projects/16.json"
  end

  it "should have created and updated at dates" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZZZ")
    date = dateFormatter.dateFromString("2014-09-09T13:36:20.000-04:00")
    @project.created_at.should.equal date
    @project.updated_at.should.equal date
  end

end
