# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define 'chef-solo' do |cs|
    cs.vm.box = "ubuntu/trusty64"
    cs.vm.network "forwarded_port", guest: 80, host: 8888

    cs.berkshelf.enabled = true
    cs.berkshelf.berksfile_path = "./cookbooks/simple_sinatra_app/Berksfile"

      cs.vm.provider 'virtualbox' do |v|
        v.memory = 1024
        v.cpus = 1
      end
  end

  config.vm.provision "chef_solo" do |chef|
    chef.run_list = ['recipe[ruby_build]', 'recipe[simple_sinatra_app]']
  end
end
