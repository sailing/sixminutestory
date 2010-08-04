namespace :db do
  namespace :sessions do
    desc "Clears stale (e.g. quarter-day old) sessions"
    task :clear_stale => :environment do
      session_count = ActiveRecord::SessionStore::Session.delete_all(['updated_at < ?', 6.hours.ago])
      puts "#{session_count} sessions removed..."
    end
  end
end


task :cron => :environment do

  # removes day old sessions from the database
  puts "====> Removing stale sessions from the database…"
  Rake::Task['db:sessions:clear_stale'].execute

end