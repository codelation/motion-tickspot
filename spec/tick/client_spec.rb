RackMotion.use TickClientStub

describe "Tick::Client" do

  before do
    session = Tick::Session.new
    session.email           = "email"
    session.password        = "password"
    session.api_token       = "f67158e7bf3d7a0fcaf9d258ace8b468"
    session.subscription_id = 15
    Tick::Session.instance_variable_set("@current", session)
  end

  it "should be defined" do
    Tick::Client.is_a?(Class).should.equal true
  end

  it "Tick::Client#list should return an array of all clients" do
    @clients = []
    Tick::Client.list do |clients|
      @clients = clients
      resume
    end

    wait do
      @clients.is_a?(Array).should.equal true
      @clients.length.should.equal 2
    end
  end

  it "should have an id" do
    @client = @clients.first
    @client.id.should.equal 12
  end

  it "should have a name" do
    @client.name.should.equal "The Republic"
  end

end
