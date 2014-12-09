class TickRoleStub

  def initialize(app)
    @app = app
  end

  def call(request)
    status = 200
    headers = {
      "Status" => "200 OK",
      "Content-Type" => "application/json; charset=utf-8"
    }

    if request.URL.absoluteString.start_with? "https://www.tickspot.com/api/v2/roles"
      data = File.open("#{NSBundle.mainBundle.resourcePath}/roles.json").read.to_data
      sleep 0.1
    else
      status, headers, data = @app.call(request)
    end

    return status, headers, data
  end

end
