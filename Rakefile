# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require "motion/project/template/ios"
require "./lib/motion-tickspot"

begin
  require "bundler"
  require "motion/project/template/gem/gem_tasks"
  Bundler.require
rescue LoadError
end

require "awesome_print_motion"
require "motion-redgreen"
require "RackMotion"

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = "Timer for Tick"
end
