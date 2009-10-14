set :application, 6ms
default_run_options[:pty] = true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"


set :deploy_to, "/srv/sixminutestory.com"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, "git"
set :repository, "git@galen.unfuddle.com:galen/sms.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "rails"
set :ssh_options, { :forward_agent => true }

role :app, application
role :web, application
role :db,  application, :primary => true

set :rails_env, "production"

# Thinking Sphinx


# http://github.com/jamis/capistrano/blob/master/lib/capistrano/recipes/deploy.rb
# :default -> update, restart
# :update  -> update_code, symlink

namespace :deploy do
  require 'vendor/plugins/thinking-sphinx/recipes/thinking_sphinx'

  task :before_update_code, :roles => [:app] do
    thinking_sphinx.stop
  end

  task :after_update_code, :roles => [:app] do
    symlink_sphinx_indexes
    thinking_sphinx.configure
    thinking_sphinx.start
  end

  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end


  
  
  task :after_update do
      run <<-CMD
        ln -nfs #{shared_path}/system/database.yml #{release_path}/config/database.yml
      CMD
        
      desc "Restarting mod_rails with restart.txt"
      task :restart, :roles => :app, :except => { :no_release => true } do
        run "touch #{current_path}/tmp/restart.txt"
      end
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

end


after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"