set :application, "chef"
set :repository,  "git://github.com/rsanheim/chef-repo.git"
set :scm, :git
set :git_enable_submodules, 1
set :deploy_via, :remote_cache    
set :normalize_asset_timestamps, false
ssh_options[:keys] = [File.join(ENV["HOME"], ".sumo", "keypair.pem")] 

instance = "ec2-67-202-34-55.compute-1.amazonaws.com"
role :web, instance
role :app, instance

before "deploy:setup", "deploy:install_git"
after "deploy", "deploy:symlink_srv"

namespace :deploy do
  desc "Install latest Git, so we can deploy"
  task :install_git do
    sudo "apt-get update -qq"
    sudo "apt-get install git-core -y"
  end
  
  %w[stop start restart].each do |name|
    desc "#{name} is a no-op"
    task(name) {}
  end
  
  desc "Symlink chef into its default location"
  task :symlink_srv do
    run "ln -sfv #{current_path} /srv/chef"
  end
end

namespace :chef do
  desc "Install Chef from gems"
  task :install_chef do
    sudo "/usr/bin/gem1.8 install chef ohai rake --source http://gems.opscode.com --source http://gems.rubyforge.org --no-ri --no-rdoc"
  end

  desc "Install Ruby from Ubuntu sources in order to allow us to install Chef"
  task :install_ruby do
    sudo "apt-get install ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb build-essential wget ssl-cert -y"
  end

  desc "Install Rubygems from source, to avoid Ubuntu badness"
  task :install_rubygems do
    set :user, "root"
    rubygems = "rubygems-1.3.5"
    run <<-EOC
if [ ! -e /usr/bin/gem ]; then
  wget -q http://rubyforge.org/frs/download.php/60718/#{rubygems}.tgz
  && tar xzf #{rubygems}.tgz
  && cd #{rubygems}
  && /usr/bin/ruby setup.rb
  && ln -s /usr/bin/gem1.8 /usr/bin/gem;
else
  echo "Rubygems already installed at /usr/bin/gem";
fi
EOC
  end
  
  desc "0 to Fully Chefized with one command"
  task :bootstrap do
    top.deploy.setup
    top.deploy.default
    install_ruby
    install_rubygems
    install_chef
    solo
  end
  
  desc "Run chef-solo"
  task :solo do
    sudo "chef-solo -j #{current_path}/config/web.json -c #{current_path}/config/solo.rb"
  end
  
end