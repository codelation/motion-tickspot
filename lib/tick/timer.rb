module Tick

  class Timer
    attr_accessor :start_time, :task, :time_spans

    def clear
      self.start_time = nil
      self.time_spans = []
      self.class.timers.delete(self)
      self.class.timers += [] # Simplify KVO
      true
    end

    def displayed_time
      hours = self.time_elapsed_in_hours.to_i
      minutes = (self.time_elapsed_in_seconds / 60).to_i - (hours * 60)

      hours = hours.to_s
      hours = "0#{hours}" if hours.length == 1

      minutes = minutes.to_s
      minutes = "0#{minutes}" if minutes.length == 1

      "#{hours}:#{minutes}"
    end

    def initialize
      self.start
      self
    end

    def is_paused
      self.start_time.nil?
    end
    alias_method :paused, :is_paused
    alias_method :paused?, :is_paused
    alias_method :is_stopped, :is_paused
    alias_method :stopped, :is_paused

    def is_running
      !self.start_time.nil?
    end
    alias_method :running, :is_running
    alias_method :running?, :is_running
    alias_method :is_started, :is_running
    alias_method :started, :is_running

    def start
      # Stop the current timer if it exists
      current_timer = self.class.current
      current_timer.stop if current_timer

      # Start the timer and add it to the
      # list of timers if it doesn't exist
      self.start_time = Time.now
      self.class.timers ||= []
      unless self.class.timers.include?(self)
        self.class.timers += [self]
      end

      true
    end
    alias_method :resume, :start

    def stop
      self.time_spans << Time.now - self.start_time
      self.start_time = nil
      true
    end
    alias_method :pause, :stop

    def submit!(options={}, &block)
      dateFormatter = NSDateFormatter.new
      dateFormatter.setDateFormat(DATE_FORMAT)

      params = {
        task_id: self.task.id,
        hours: self.time_elapsed_in_hours,
        date: Time.now
      }.merge!(options)

      entry = Entry.create(params) do |result|
        self.clear
        block.call(result) if block
      end

      self
    end

    def time_elapsed_in_seconds
      time_elapsed_in_seconds = 0

      # Add up time spans
      self.time_spans.each do |seconds|
        time_elapsed_in_seconds += seconds
      end

      # Add the current running time
      if self.start_time
        time_elapsed_in_seconds += Time.now - self.start_time
      end

      time_elapsed_in_seconds
    end

    def time_elapsed_in_hours
      self.time_elapsed_in_seconds / 60 / 60
    end

    def time_spans
      @time_spans ||= []
    end

    class << self
      attr_accessor :timers

      def current
        list.select{|timer|
          timer.is_running
        }.first
      end

      def list
        timers || []
      end

      def start_with_task(task)
        timer = list.select{|timer|
          timer.task.id == task.id
        }.first

        if timer.nil?
          timer = new
          timer.task = task
        end

        if timer.is_paused
          timer.start
        end

        timer
      end

    end

  end

end
