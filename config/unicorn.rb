root = File.expand_path "#{File.dirname(__FILE__)}/.."

worker_processes_map = { default: 2, fiit_production: 4, fiit_demo: 1, fiit_staging: 1, edx_production: 1, edx_demo: 1, edx_staging: 1, lugano_production: 1, novisad_production: 1 }

worker_processes worker_processes_map[(ENV['RAILS_ENV'] || :default).to_sym]
timeout          15
preload_app      true
listen           "#{root}/shared/.unicorn.sock", backlog: 64
pid              "#{root}/tmp/pids/unicorn.pid"
stderr_path      "#{root}/log/unicorn.log"
stdout_path      "#{root}/log/unicorn.log"

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = "#{root}/tmp/pids/unicorn.pid.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # Someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection

  ##
  # Unicorn master is started as root, which is fine, but let's
  # drop the workers to git:git
  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'deploy', 'deploy'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid

    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    raise e
  end
end
