class TickEntryStub

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
    elsif request.URL.absoluteString.start_with? "https://www.tickspot.com/15/api/v2/entries"
      if request.HTTPMethod == "POST"
        data = File.open("#{NSBundle.mainBundle.resourcePath}/create_entry.json").read.to_data
      else
        data = File.open("#{NSBundle.mainBundle.resourcePath}/entries.json").read.to_data
      end
      sleep 0.1
    else
      status, headers, data = @app.call(request)
    end

    return status, headers, data
  end

end
