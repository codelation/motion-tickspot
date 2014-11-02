require "motion-cocoapods"

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

lib_dir_path = File.dirname(File.expand_path(__FILE__))
Motion::Project::App.setup do |app|
  app.files.unshift(Dir.glob(File.join(lib_dir_path, "tick/**/*.rb")))

  app.pods do
    pod "AFNetworking", "~> 2.4"
    pod "GDataXML-HTML", "~> 1.2"
    pod "SSKeychain", "~> 1.2"
  end
end
