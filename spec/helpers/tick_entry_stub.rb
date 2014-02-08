class TickEntryStub
  
  def initialize(app)
    @app = app
  end
 
  def call(request)
    status = 200
    headers = {
      "Status" => "200 OK",
      "Content-Type" => "application/xml; charset=utf-8"
    }
    if request.URL.absoluteString.start_with? "https://company.tickspot.com/api/create_entry" 
      data = File.open("#{NSBundle.mainBundle.resourcePath}/create_entry.xml").read.to_data
      sleep 0.1
    elsif request.URL.absoluteString.start_with? "https://company.tickspot.com/api/entries?"
      data = File.open("#{NSBundle.mainBundle.resourcePath}/entries.xml").read.to_data
      sleep 0.1
    else
      status, headers, data = @app.call(request)
    end
    
    return status, headers, data
  end
  
end