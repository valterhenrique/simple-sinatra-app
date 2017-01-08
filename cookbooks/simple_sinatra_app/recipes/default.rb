#
# Cookbook:: simple_sinatra_app
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'update-and-upgrade' do
  command 'apt-get update && apt-get upgrade -y'
  user 'root'
  action :run
end

apt_update 'Update APT cache daily' do
  frequency 86_400 # 86,400 seconds = 1 day; The _ notation is a Ruby convention that helps make numeric values more readable.
  action :periodic
end

ruby_build_ruby '2.4.0' do
  prefix_path '/usr/local'
  action :install
end

package 'apache2'

swap_file '/mnt/swap' do
  size      1024    # MBs
end

# http://recipes.sinatrarb.com/p/deployment/apache_with_passenger
# Packages necessary to compile passenger
package 'libcurl4-openssl-dev'
package 'apache2-dev'
package 'libapr1-dev'
package 'libaprutil1-dev'

execute 'install-bundler' do
  command 'gem install bundler'
  user 'root'
  action :run
  not_if 'gem list | grep bundler'
end

execute 'install-bundler' do
  command 'gem install passenger'
  user 'root'
  action :run
  not_if 'gem list | grep passenger'
end

execute 'compile-apache-passenger' do
  command 'passenger-install-apache2-module -a'
  user 'root'
  action :run
  not_if {File.exists?("/usr/local/lib/ruby/gems/2.4.0/gems/passenger-5.1.1/buildout/apache2/mod_passenger.so")}
end

cookbook_file '/etc/apache2/sites-available/000-default.conf' do
  source '000-default.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

group 'sinatra_app'
user 'sinatra_app' do
  group 'sinatra_app'
  system true
  shell '/bin/bash'
end

application '/srv/simple-sinatra-app' do
  owner 'sinatra_app'
  group 'sinatra_app'

  package 'ruby'
  git "/srv/simple-sinatra-app" do
    repository "git://github.com/tnh/simple-sinatra-app.git"
    reference "master"
    action :sync
  end

  execute "run-bundle-install" do
     command "cd /srv/simple-sinatra-app && bundle install"
     user 'root'
     action :run
  end

  execute "chown-simple-sinatra-app-folder" do
    command "chown -R sinatra_app:sinatra_app /srv/simple-sinatra-app"
    user "root"
    action :run
    # not_if "stat -c %U /srv/simple-sinatra-app |grep sinatra_app"
  end

  directory '/srv/simple-sinatra-app/public' do
    owner 'sinatra_app'
    group 'sinatra_app'
    mode '0755'
    action :create
  end

  directory '/srv/simple-sinatra-app/tmp' do
    owner 'sinatra_app'
    group 'sinatra_app'
    mode '0755'
    action :create
  end

  service 'apache2' do
    supports :status => true
    action [:enable, :start]
  end
end
