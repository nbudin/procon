# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

#require 'mongrel_cluster/recipes'

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "procon"
set :repository, "git://github.com/nbudin/procon.git"

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

role :web, "sakai.natbudin.com"
role :app, "sakai.natbudin.com"
role :db,  "sakai.natbudin.com", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/var/www/events.brandeislarp.com"
#set :deploy_to, "/var/www/procon-staging.natbudin.com"
set :use_sudo, false
set :checkout, "export"
set :user, "www-data"            # defaults to the currently logged in user
set :deploy_via, :remote_cache
set :scm, :git               # defaults to :subversion
set :git_enable_submodules, 1


# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)
namespace :deploy do
  desc "Tell Passenger to restart this app"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Link in database config and attachments"
  task :after_update_code do
    run "rm -f #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "rm -f #{release_path}/config/scout.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/scout.yml #{release_path}/config/scout.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/attached_images #{release_path}/public/attached_images"
  end
end
  
