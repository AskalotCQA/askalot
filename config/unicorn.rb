root = Rails.root

worker_processes 8
timeout          15
preload_app      true
listen           root.join('shared/.unicorn.sock'), backlog: 64
pid              root.join('tmp/pids/unicorn.pid')
stderr_path      root.join('log/unicorn.log')
stdout_path      root.join('log/unicorn.log')

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
