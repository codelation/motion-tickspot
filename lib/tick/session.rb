module Tick
  
  class Session < Tick::Base
    attr_accessor :company, :email, :first_name, :last_name, :password
  
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
    
    def destroy
      storage.removeObjectForKey("company")
      storage.removeObjectForKey("email")
      SSKeychain.deletePasswordForService(SERVICE_NAME, account:email)
      self.class.current = nil
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
    
    def first_name
      @first_name ||= storage.objectForKey("first_name")
    end
  
    def first_name=(value)
      @first_name = value
      storage.setObject(value, forKey:"first_name")
      storage.synchronize
      @first_name
    end
    
    def last_name
      @last_name ||= storage.objectForKey("last_name")
    end
  
    def last_name=(value)
      @last_name = value
      storage.setObject(value, forKey:"last_name")
      storage.synchronize
      @last_name
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
    
    def self.create(params, &block)
      url  = "https://#{params[:company]}.tickspot.com/api/users"
    
      params.delete(:company)
  
      request_manager.GET(url, parameters:params, success:lambda{|operation, result|
        # TODO: Save first and last name
        @current = new
        @current.company = params[:company]
        @current.email = params[:email]
        @current.password = params[:password]
        block.call(@current) if block
      }, failure:lambda{|operation, error|
        block.call(error) if block
      })
    
      self
    end
  
    def self.current
      @current || new if logged_in?
    end
    
    def self.logged_in?
      @current && @current.company && @current.email && @current.password
    end
  
  end
  
end