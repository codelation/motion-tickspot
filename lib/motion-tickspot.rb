require "motion-cocoapods"
require "motion-keychain"

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

lib_dir_path = File.dirname(File.expand_path(__FILE__))
Motion::Project::App.setup do |app|
  app.files.unshift(Dir.glob(File.join(lib_dir_path, "tick/**/*.rb")))

  app.pods do
    pod "AFNetworking", "~> 2.5"
    pod "AFNetworkActivityLogger", "~> 2.0"
  end
end
