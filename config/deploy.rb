# New Repo Steps:
#   gem install capistrano
#   capify .
#   cap deploy:setup
#   cap deploy:check
# Note: you may have to remove the following for the first cap deploy
#   after "deploy:symlink", "deploy:bundle_install"
# * You will also need to make sure git is installed -- http://docs.webfaction.com/software/git.html
# * Don't forget to setup paths once that is done:
#   cd ~/webapps/rails
#   export GEM_HOME=$PWD/gems
#   export PATH=$PWD/bin:$PATH
#   export RUBYLIB=$PWD/lib:$RUBYLIB
# 
# Setup (taken mostly from http://forum.webfaction.com/viewtopic.php?id=4906)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :app_name, "cri"
set :webfaction_username, "cri"
set :webfaction_port, "29299"

set :webfaction_db_type, "mysql"
set :webfaction_db, "cri_prod"
set :webfaction_db_username, "cri_prod"
# set :database_yml_template, "database.yml"

set :deploy_to, "/home/#{webfaction_username}/webapps-releases/#{app_name}"
 
set :scm, :git
set :scm_user, "younker"
set :scm_verbose, true
set :repository, "git@github.com:younker/CRI.git"
 
set :user, "#{webfaction_username}"
set :use_sudo, false 
 
set :domain, "#{webfaction_username}.webfactional.com"
 
role :app, domain
role :web, domain
role :db,  domain, :primary => true
 
default_environment['PATH']='/home/cri/webapps/git/bin:/home/cri/webapps/cri/bin:/home/cri/bin:/usr/local/bin:/usr/local/mysql/bin:/opt/local/apache2/bin:/opt/local/bin:/Users/younker/.rvm/gems/ruby-1.8.7-p302/bin:/usr/kerberos/bin:/bin:/usr/bin'
default_environment['GEM_HOME']='/home/cri/webapps/cri/gems'

# Basic Capistrano Deployment Steps:
#   deploy:update_code
#   deploy:symlink
#   deploy:restart
namespace :deploy do
  desc "Symlink all the /shared assets to their new version-specific path"
  task :symlink do
    # release_path = /home/cri/webapps-releases/cri/releases/20110407164415
    # deploy_to    = /home/cri/webapps-releases/cri
    run "ln -nfs #{release_path} #{deploy_to}/current"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/contact.yml #{release_path}/config/contact.yml"
    run "ln -nfs #{shared_path}/assets/images/blog #{release_path}/app/assets/images/blog"
    run "ln -nfs #{shared_path}/assets/images/team_members #{release_path}/app/assets/images/team_members"
    # run "ln -nfs #{shared_path}/assets #{release_path}/public/"
    run "ln -nfs #{shared_path}/certs #{release_path}"
  end

  # A cron job is created to restart the nginx server every 20 minutes if it is not already running.
  #    To restart nginx, run: ~/webapps/<app_name>/bin/restart
  #    To start nginx, run: ~/webapps/<app_name>/bin/start
  #    To stop nginx, run: ~/webapps/<app_name>/bin/stop
  desc "Redefine deploy:restart"
  task :restart, :roles => :app do
    run "/home/#{webfaction_username}/webapps/#{app_name}/bin/restart"
  end
  # TODO younker [2011-04-19 10:05]
  # For some reasons, deploy:restart is NOT firing after deploy:symlink. Figure out why, but until then...
  after "deploy:bundle_install", "deploy:restart"

  desc "Redefine deploy:start"
  task :start, :roles => :app do
    run "/home/#{webfaction_username}/webapps/#{app_name}/bin/start"
  end
 
  desc "Redefine deploy:stop"
  task :stop, :roles => :app do
    run "/home/#{webfaction_username}/webapps/#{app_name}/bin/stop"
  end


  ##
  ## Custom Tasks
  ##
  desc "bundle install the necessary prerequisites"
  task :bundle_install, :roles => :app do
    run "cd #{deploy_to}/current/ && /home/cri/webapps/#{app_name}/bin/bundle install"
  end
  after "deploy:symlink", "deploy:bundle_install"

  desc "compile assets"
  task :compile_assets, :roles => :app do
    run "cd #{deploy_to}/current/ && /home/cri/webapps/#{app_name}/bin/bundle exec compass compile -e production --force"
  end
  after "deploy:bundle_install", "deploy:compile_assets"
end



# task :staging do
#   role :web, 'staging.whoz.in'
#   role :app, 'staging.whoz.in'
#   role :db, 'staging.whoz.in', :primary => true
# end
# 
# task :production do
# end