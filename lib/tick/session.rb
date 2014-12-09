module Tick

  class AuthenticationError < Exception
  end

  class Session < Tick::Base
    attr_accessor :api_token, :email, :password, :roles, :subscription_id

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

    def roles
      @roles ||= []
    end

    def self.create(params, &block)
      @current.email = params[:email]
      @current.password = params[:password]

      Tick::Role.list do |roles|
        if roles
          @current.roles = roles
          block.call(@current) if block
        else
          self.destroy
          block.call(nil) if block
        end
      end

      self
    end

    def self.current
      @current || new
    end

    def self.current=(value)
      @current = value
    end

    def self.logged_in?
      (current.email && current.password) ? true : false
    end
  end

end
