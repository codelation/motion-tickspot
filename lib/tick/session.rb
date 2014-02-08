module Tick
  
  class Session
    attr_accessor :company, :email, :password
  
    SERVICE_NAME = "Tick Timer"
  
    def company
      @company ||= storage.objectForKey("company")
    end
  
    def company=(value)
      @company = value
      storage.setObject(value, forKey:"company")
      storage.synchronize
      @company
    end
  
    def email
      @email ||= storage.objectForKey("email")
    end
  
    def email=(value)
      @email = value
      storage.setObject(value, forKey:"email")
      storage.synchronize
      @email
    end
  
    def logged_in?
      (self.company && self.email && self.password) ? true : false
    end
  
    def login(company, email, password)
      url  = "https://#{company}.tickspot.com/api/users"
    
      params = {
        email: email,
        password: password
      }
    
      promise = Loco::Promise.new
  
      AFMotion::XML.get(url, params) do |result|
        if result.success?
          self.company = company
          self.email = email
          self.password = password
          promise.resolve(result.body)
        elsif result.failure?
          promise.reject(result.error)
        end
      end
    
      promise
    end
  
    def logout
      SSKeychain.deletePasswordForService(SERVICE_NAME, account:email)
    end
  
    def password
      @password ||= SSKeychain.passwordForService(SERVICE_NAME, account:email)
    end
  
    def password=(value)
      @password = value
      SSKeychain.setPassword(value, forService:SERVICE_NAME, account:email)
      @password
    end
  
    def storage
      NSUserDefaults.standardUserDefaults
    end
  
    def self.current
      @instance ||= new
    end
  
  end
  
end