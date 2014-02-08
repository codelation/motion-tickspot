RackMotion.use TickClientStub

describe "Tick::Client" do
  
  before do
    Tick::Session.current.company  = "company"
    Tick::Session.current.email    = "email"
    Tick::Session.current.password = "password"
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
      @clients.length.should.equal 3
    end
  end
  
  it "should have an id" do
    @client = @clients.first
    @client.id.should.equal 12341
  end
  
  it "should have a name" do
    @client.name.should.equal "Starfleet Command"
  end
  
end