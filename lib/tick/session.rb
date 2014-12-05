module Tick

  class AuthenticationError < Exception
  end

  class Session < Tick::Base
    attr_accessor :company, :email, :first_name, :last_name, :password

    def destroy
      MotionKeychain.remove("email")
      MotionKeychain.remove("password")
      self.class.current = nil
    end

    def email
      @email ||= MotionKeychain.get("email")
    end

    def email=(value)
      @email = value
      MotionKeychain.set("email", @email)
      @email
    end

    def password
      @password ||= MotionKeychain.get("password")
    end

    def password=(value)
      @password = value
      MotionKeychain.set("password", @password)
      @password
    end

    def self.create(params, &block)
      manager = request_manager
      manager.requestSerializer.setAuthorizationHeaderFieldWithUsername(params[:email], password: params[:password])
      url  = "https://www.tickspot.com/api/v2/roles.json"

      manager.GET(url, parameters: nil, success: ->(operation, result) {
        # # TODO: Save first and last name
        # @current = new
        # @current.company = company
        # @current.email = params[:email]
        # @current.password = params[:password]
        # block.call(@current) if block
        @current = new
        @current.first_name = result
        block.call(@current) if block
      }, failure: ->(operation, error) {
        mp "ERROR:"
        mp error.userInfo
        block.call(nil) if block
      })

      self
    end

    def self.current
      @current || new
    end

    def self.current=(value)
      @current = value
    end

    def self.logged_in?
      (current.company && current.email && current.password) ? true : false
    end

  end

end
