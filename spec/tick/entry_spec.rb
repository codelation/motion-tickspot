RackMotion.use TickEntryStub

describe "Tick::Entry" do
  
  before do
    Tick::Session.current.company  = "company"
    Tick::Session.current.email    = "email"
    Tick::Session.current.password = "password"
  end
  
  it "should be defined" do
    Tick::Entry.is_a?(Class).should.equal true
  end
  
  it "should save new entries" do
    @result = nil
    Tick::Entry.create({
      task_id: 1,
      hours: 10,
      date: "2014-01-27"
    }) do |result|
      @result = result
      resume
    end
    
    wait do
      @result.is_a?(GDataXMLDocument).should.equal true
    end
  end
  
  it "Tick::Entry#list should return an array of all tasks for the given project" do
    @tasks = []
    Tick::Entry.list do |entries|
      @entries = entries
      resume
    end
    
    wait do
      @entries.is_a?(Array).should.equal true
      @entries.length.should.equal 1
    end
  end
  
  it "should have an id" do
    @entry = @entries.first
    @entry.id.should.equal 24
  end
  
  it "should have a task id" do
    @entry.task_id.should.equal 14
  end
  
  it "should have a user id" do
    @entry.user_id.should.equal 3
  end
  
  it "should have a date" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd")
    date = dateFormatter.dateFromString("2008-03-08")
    @entry.date.should.equal date
  end
  
  it "should have created and updated at dates" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("EE, dd MM yyyy hh:mm:ss zzz")
    date = dateFormatter.dateFromString("Tue, 07 Oct 2008 14:46:16 -0400")
    @entry.created_at.should.equal date
    @entry.updated_at.should.equal date
  end
  
  it "should have hours" do
    @entry.hours.should.equal 1.00
  end
  
  it "should have notes" do
    @entry.notes.should.equal "Had trouble with tribbles."
  end
  
  it "should have a billable attribute" do
    @entry.billable.should.equal true
  end
  
  it "should have a billed attribute" do
    @entry.billed.should.equal true
  end
  
  it "should have a user's email" do
    @entry.user_email.should.equal "scotty@enterprise.com"
  end
  
  it "should have a task name" do
    @entry.task_name.should.equal "Remove converter assembly"
  end
  
  it "should have the sum of hours" do
    @entry.sum_hours.should.equal 2.00
  end
  
  it "should have a budget" do
    @entry.budget.should.equal 10.00
  end
  
  it "should have a project name" do
    @entry.project_name.should.equal "Realign dilithium crystals"
  end
  
  it "should have a client name" do
    @entry.client_name.should.equal "Starfleet Command"
  end
  
end