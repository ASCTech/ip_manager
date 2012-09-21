require 'bundler/capistrano'
require 'rvm/capistrano'

load 'deploy'
load 'deploy/assets'

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

set :application, "ipmanager"
set :repository,  "git@github.com:ASCTech/ip_manager.git"

set :keep_releases, 3

set :scm, :git
set :use_sudo, false

set :deploy_to, "/var/www/apps/#{application}"

set :branch, "master"
set :branch, $1 if `git branch` =~ /\* (\S+)\s/m
set :deploy_via, :remote_cache

set :user, 'deploy'
set :ssh_options, { :forward_agent => true, :port => 2200 }


task :staging do
  set :rails_env, "staging"
  role :app, "ruby-test.asc.ohio-state.edu"
  role :web, "ruby-test.asc.ohio-state.edu"
  role :db, "ruby-test.asc.ohio-state.edu", :primary => true
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"

  end

  desc "Places seed data in database"
  task :seed, :roles => :app do
    run "cd #{current_path} && #{rake} RAILS_ENV=#{rails_env} db:seed"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end
end

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

before "deploy:assets:precompile" do
  run [
    "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml",
    "ln -fs #{shared_path}/uploads #{release_path}/uploads",
    "ln -fs #{shared_path}/tmp/pids #{release_path}/tmp/pids",
    "rm #{release_path}/public/system"
  ].join(" && ")
end

after "deploy:create_symlink", "deploy:cleanup"
