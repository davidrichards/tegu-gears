GEM_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
CONFIG_ROOT = File.expand_path(File.join(%w(~ .tegu tegu_gears)))
LOG_ROOT = File.expand_path(File.join(CONFIG_ROOT, 'log'))
THREAD_POOL_PID_FILE = File.join(LOG_ROOT, 'thread_pool.pid')
THREAD_POOL_LOG_FILE = File.join(LOG_ROOT, 'thread_pool.log')

require 'fileutils'
FileUtils.mkdir_p(LOG_ROOT)


def generic_monitoring(w, opts={})
  w.behavior(:clean_pid_file)
  
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end
  
  w.restart_if do |start|
    start.condition(:memory_usage) do |c|
      c.above = opts[:memory_limit]
      c.times = [3,5] # 3 out of 5 times
    end
    
    start.condition(:cpu_usage) do |c|
      c.above = opts[:cpu_limit]
      c.times = 5
    end
  end
  
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minutes
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

God.watch do |w|
  w.name = "tegu-gears-thread-pool"
  w.group = "tegu-gears"
  w.interval = 60.seconds
  w.start = %{
    #{GEM_ROOT}/bin/tegu_gears_thread_pool > #{THREAD_POOL_LOG_FILE} 2>&1 &
    echo $! > #{THREAD_POOL_PID_FILE}
  }
  w.stop = "kill `cat #{THREAD_POOL_PID_FILE}`"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = THREAD_POOL_PID_FILE
  
  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 1.gigabyte)

end
