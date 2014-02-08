class TickProjectStub
  
  def initialize(app)
    @app = app
  end
 
  def call(request)
    if request.URL.absoluteString.start_with? "https://company.tickspot.com/api/projects?"
      status = 200
      headers = {
        "Status" => "200 OK",
        "Content-Type" => "application/xml; charset=utf-8"
      }
      data = File.open("#{NSBundle.mainBundle.resourcePath}/projects.xml").read.to_data
      sleep 0.1
    else
      status, headers, data = @app.call(request)
    end
    
    return status, headers, data
  end
  
end