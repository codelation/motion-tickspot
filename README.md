# Motion-Tickspot

[![Build Status](https://travis-ci.org/codelation/motion-tickspot.png?branch=master)](https://travis-ci.org/codelation/motion-tickspot)
[![Code Climate](https://codeclimate.com/github/codelation/motion-tickspot.png)](https://codeclimate.com/github/codelation/motion-tickspot)

A [RubyMotion](http://www.rubymotion.com) wrapper for
[Tick](http://www.tickspot.com)'s [API](http://www.tickspot.com/api)
that works on iOS and OS X.

## WARNING

This gem is no longer being actively developed. Tick released V2 of their API, which was a step forward in being RESTful and using JSON instead of XML. Unfortunately is was a step backwards when it comes to usability. What was previously accomplished in a single API request now takes multiple requests. You can check out the [api-v2](https://github.com/codelation/motion-tickspot/tree/api-v2) branch, but I'm not proud of it and I really don't like the new API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "motion-tickspot"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install motion-tickspot
```

## Usage

### Authentication

Authentication is handled by `Tick::Session` with some convenience methods.

[SSKeychain](https://github.com/soffes/sskeychain) is being used to 
save the user's password to the iOS or OS X keychain.

```ruby
Tick.logged_in? # true/false

Tick.log_in("company/subdomain", "email@example.com", "password") do |session|
  if session
    # Success!
  else
    # Failed to log in
  end
end

Tick.log_out
```

### Tick::Client

```ruby
Tick::Client.list do |clients|
  # Returns array of Tick::Clients
  # Raises Tick::AuthenticationError if not logged in
end
```

### Tick::Entry

```ruby
Tick::Entry.create({
  task_id: 1,
  hours: 2.5,
  date: "2008-03-17",
  notes: "She can't take much more of this Captain"
}) do |entry|
  # Returns the saved Tick::Entry
  # Raises Tick::AuthenticationError if not logged in
end
```

```ruby
Tick::Entry.list do |entries|
  # Returns array of Tick::Entries
  # Raises Tick::AuthenticationError if not logged in
end
```

### Tick::Project

```ruby
Tick::Project.list do |projects|
  # Returns array of Tick::Projects
  # Raises Tick::AuthenticationError if not logged in
end
```

### Tick::Session

```ruby
Tick::Session.current
# Returns Tick::Session instance or nil
```

### Tick::Task

```ruby
Tick::Task.list do |tasks|
  # Returns array of Tick::Tasks
  # Raises Tick::AuthenticationError if not logged in
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
