describe "Tick::Timer" do
  
  it "should be defined" do
    Tick::Timer.is_a?(Class).should.equal true
  end
  
  it "should start a new timer with a task" do
    task = Tick::Task.new
    task.id = 1
    @timer = Tick::Timer.start_with_task(task)
    @timer.task.id.should.equal 1
  end
  
  it "should use the previously created timer if it exists for the task" do
    task = Tick::Task.new
    task.id = 1
    previous_timer = Tick::Timer.start_with_task(task)
    previous_timer.should.equal @timer
  end
  
  it "should return whether or not the timer is running" do
    @timer.is_running.should.equal true
    @timer.is_paused.should.equal false
    
    @timer.stop
    @timer.is_running.should.equal false
    @timer.is_paused.should.equal true
    
    @timer.start
    @timer.is_running.should.equal true
    @timer.is_paused.should.equal false
  end
  
  it "should return the current running timer" do
    Tick::Timer.current.should.equal @timer
  end
  
  it "should list all started timers" do
    timers = Tick::Timer.list
    timers.is_a?(Array).should.equal true
    timers.length.should.equal 1
    timers.first.should.equal @timer
  end
  
  it "should pause all other timers when a new timer is started" do
    task = Tick::Task.new
    task.id = 2
    new_timer = Tick::Timer.start_with_task(task)
    
    Tick::Timer.current.should.equal new_timer
    timers = Tick::Timer.list
    timers.length.should.equal 2
    timers.each do |timer|
      if timer.task.id == 2
        timer.is_running.should.equal true
        timer.is_paused.should.equal false
      else
        timer.is_running.should.equal false
        timer.is_paused.should.equal true
      end
    end
    
    task = Tick::Task.new
    task.id = 3
    another_timer = Tick::Timer.start_with_task(task)
    
    Tick::Timer.current.should.equal another_timer
    timers = Tick::Timer.list
    timers.length.should.equal 3
    timers.each do |timer|
      if timer.task.id == 3
        timer.is_running.should.equal true
        timer.is_paused.should.equal false
      else
        timer.is_running.should.equal false
        timer.is_paused.should.equal true
      end
    end
  end
  
  it "should have a time span for each start and stop" do
    task = Tick::Task.new
    task.id = 4
    
    timer = Tick::Timer.start_with_task(task)
    timer.stop
    timer.time_spans.length.should.equal 1
    
    timer.start
    timer.stop
    timer.time_spans.length.should.equal 2
  end
  
  it "should calculate the time in seconds and hours based on recorded time spans" do
    timer = Tick::Timer.new
    timer.time_spans = [7200, 5400, 3600] # 2 hours, 1.5 hours, 1 hour
    timer.time_elapsed_in_seconds.to_i.should.equal 16200
    timer.time_elapsed_in_hours.should.equal 4.5
  end
  
  it "should have the displayed time as hours and minutes: '04:30'" do
    timer = Tick::Timer.new
    timer.time_spans = [7200, 5400, 3600] # 2 hours, 1.5 hours, 1 hour
    timer.displayed_time.should.equal "04:30"
  end
  
  it "should be removed from list of timers when cleared" do
    Tick::Timer.list.length.should.equal 6
    timer = Tick::Timer.list.select{|timer|
      timer.is_paused
    }.first
    timer.clear
    Tick::Timer.list.length.should.equal 5
  end
  
  it "should be removed from list of timers when the time is submitted" do
    Tick::Timer.list.length.should.equal 6
    timer = Tick::Timer.list.select{|timer|
      timer.is_paused
    }.first
    timer.submit!
    Tick::Timer.list.length.should.equal 5
  end
  
end