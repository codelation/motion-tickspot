RackMotion.use TickRoleStub

describe "Tick::Role" do

  before do
    session = Tick::Session.new
    session.email    = "email"
    session.password = "password"
    Tick::Session.instance_variable_set("@current", session)
  end

  it "should be defined" do
    Tick::Role.is_a?(Class).should.equal true
  end

  it "Tick::Role#list should return an array of all roles" do
    @roles = []
    Tick::Role.list do |roles|
      @roles = roles
      resume
    end

    wait do
      @roles.is_a?(Array).should.equal true
      @roles.length.should.equal 2
    end
  end

  it "should have an api_token" do
    @role = @roles.first
    @role.api_token.should.equal "f67158e7bf3d7a0fcaf9d258ace8b468"
  end

  it "should have a company" do
    @role.company.should.equal "Empire"
  end

  it "should have a subscription_id" do
    @role.subscription_id.should.equal 15
  end

end
