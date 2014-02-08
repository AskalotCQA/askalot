root = File.expand_path "#{File.dirname(__FILE__)}/.."

worker_processes 8
timeout          15
preload_app      false
listen           "#{root}/shared/.unicorn.sock", backlog: 64
pid              "#{root}/tmp/pids/unicorn.pid"
stderr_path      "#{root}/log/unicorn.log"
stdout_path      "#{root}/log/unicorn.log"

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
