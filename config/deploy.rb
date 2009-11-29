set :application, 'sixminutestory.com'

task :to_dev do
  
default_run_options[:pty] = true

set :location, '192.168.1.105'
role :app, location
role :web, location
role :db,  location, :primary => true

set :deploy_to, "/home/rails/www/sixminutestory.com"
set :user, "rails"
set :runner, "rails"

end

task :to_stage do
  
default_run_options[:pty] = true

role :app, application
role :web, application
role :db,  application, :primary => true

set :deploy_to, "/home/rails/www/stage.sixminutestory.com"
set :user, "rails"
set :runner, "rails"

end


task :to_prod do
  
default_run_options[:pty] = true

role :app, application
role :web, application
role :db,  application, :primary => true

set :deploy_to, "/home/rails/www/sixminutestory.com"
set :user, "rails"
set :runner, "rails"

end

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, "git"
set :repository, "git@galen.unfuddle.com:galen/sms.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :use_sudo, false
set :ssh_options, { :forward_agent => true }


set :rails_env, "production"

# Thinking Sphinx
namespace :thinking_sphinx do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :index, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
end

# Thinking Sphinx typing shortcuts
namespace :ts do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :in, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
end


namespace :deploy do
  namespace :web do
    task :disable, :roles => :web do
          # invoke with  
          # UNTIL="16:00 MST" REASON="a database upgrade" cap deploy:web:disable

          on_rollback { rm "#{current_path}/public/maintenance.html" }

          require 'erb'
          deadline, reason = ENV['UNTIL'], ENV['REASON']
          maintenance = ERB.new(File.read("./app/views/layouts/maintenance.erb")).result(binding)

          put maintenance, "#{current_path}/public/maintenance.html", :mode => 0644
    end
  end
  
  task :before_update do
    # Stop Thinking Sphinx before the update so it finds its configuration file.
   thinking_sphinx.stop
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  
  task :after_update do
      run <<-CMD
        ln -nfs #{shared_path}/system/database.yml #{release_path}/config/database.yml
      CMD
      
    
    thinking_sphinx.configure
    thinking_sphinx.index
    thinking_sphinx.start
    symlink_sphinx_indexes

  end 
  	
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Link up Sphinx's indexes."
    task :symlink_sphinx_indexes, :roles => [:app] do
      run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
    end

  desc "Update the crontab file"
	  task :update_crontab, :roles => :db do
	    run "cd #{release_path} && whenever --update-crontab #{application}"
    end
end

after "deploy:symlink", "deploy:update_crontab"
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"