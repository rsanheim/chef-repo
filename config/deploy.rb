set :application, "set your application name here"
set :repository,  "set your repository location here"

set :scm, :subversion

role :web, "ec2-174-129-180-22.compute-1.amazonaws.com"
role :app, "ec2-174-129-180-22.compute-1.amazonaws.com"
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart do
  end
end

namespace :chef do
  task :web_json, :roles => :web do
    puts 'hi'
    run "whoami"
  end
  
  task :install_chef do
    sudo "/usr/bin/gem1.8 install chef ohai rake --source http://gems.opscode.com --source http://gems.rubyforge.org --no-ri --no-rdoc"
  end

  desc "Install Ruby from Ubuntu sources in order to allow us to install Chef"
  task :install_ruby do
    sudo "apt-get install ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb build-essential wget ssl-cert -y"
  end

  task :install_rubygems do
    set :user, "root"
    rubygems = "rubygems-1.3.5"
    run <<-EOC
if [ ! -e /usr/bin/gem ]; then
  wget http://rubyforge.org/frs/download.php/60718/#{rubygems}.tgz
  && tar xzf #{rubygems}.tgz
  && cd #{rubygems}
  && /usr/bin/ruby setup.rb
  && ln -s /usr/bin/gem1.8 /usr/bin/gem;
else
  echo "Rubygems already installed at /usr/bin/gem";
fi
EOC
  end
  
  task :bootstrap do
    top.deploy.setup
    top.deploy.default
    install_ruby
    install_rubygems
    install_chef
    # solo
  end
  
end