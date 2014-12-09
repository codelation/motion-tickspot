RackMotion.use TickEntryStub

describe "Tick::Entry" do

  before do
    session = Tick::Session.new
    session.email           = "email"
    session.password        = "password"
    session.api_token       = "f67158e7bf3d7a0fcaf9d258ace8b468"
    session.subscription_id = 15
    Tick::Session.instance_variable_set("@current", session)
  end

  it "should be defined" do
    Tick::Entry.is_a?(Class).should.equal true
  end

  it "should save new entries" do
    @result = nil
    Tick::Entry.create({
      task_id: 24,
      hours: 1.5,
      date: "2014-09-18",
      notes: "Chasing Ewoks"
    }) do |result|
      @result = result
      resume
    end

    wait do
      @result.is_a?(Tick::Entry).should.equal true
      @result.task_id.should.equal 24
      @result.hours.round(1).should.equal 1.5
      dateFormatter = NSDateFormatter.new
      dateFormatter.setDateFormat("yyyy-MM-dd")
      date = dateFormatter.dateFromString("2014-09-18")
      @result.date.is_a?(NSDate).should.equal true
      @result.date.should.equal date
    end
  end

  it "Tick::Entry#list should return an array of all time entries" do
    @tasks = []
    Tick::Entry.list do |entries|
      @entries = entries
      resume
    end

    wait do
      @entries.is_a?(Array).should.equal true
      @entries.length.should.equal 2
    end
  end

  it "should have an id" do
    @entry = @entries.first
    @entry.id.should.equal 234
  end

  it "should have a task id" do
    @entry.task_id.should.equal 24
  end

  it "should have a user id" do
    @entry.user_id.should.equal 4
  end

  it "should have a date" do
    dateFormatter = NSDateFormatter.new
    dateFormatter.setDateFormat("yyyy-MM-dd")
    date = dateFormatter.dateFromString("2014-09-17")
    @entry.date.should.equal date
  end

  it "should have hours" do
    @entry.hours.round(1).to_s.should.equal "2.9"
  end

  it "should have notes" do
    @entry.notes.should.equal "Stocking up on Bacta."
  end
end
