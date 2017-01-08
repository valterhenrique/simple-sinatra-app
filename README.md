# Simple Sinatra App

## Specifications
This project was developed, for simplicity, with [Vagrant][vagrant], [VirtualBox][virtualbox], and [chef solo provisioner][chef-solo-provisioner] as provisioner.

## Installation

### VirtualBox
[Download VirtualBox][download-virtualbox] from the Oracle web site.

or

If you're using Ubuntu:

```
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" >> /etc/apt/sources.list.d/virtualbox.list'
sudo apt update
sudo apt install virtualbox-5.1

VBoxManage --version
5.1.12r112440
```

### Install DKMS

_Note: Ubuntu/Debian users might want to install the dkms package to ensure that the VirtualBox host kernel modules (vboxdrv, vboxnetflt and vboxnetadp) are properly updated if the linux kernel version changes during the next apt-get upgrade._
```
sudo apt-get install virtualbox-dkms
```

### Vagrant
[Download Vagragrant][download-vagrant] from HashiCorp web site.

```
vagrant --version
Vagrant 1.9.1
```

#### Vagrant plugins

You may need to install these _vagrant plugins_ as well:

```
vagrant plugin install vagrant-berkshelf
vagrant plugin vagrant-omnibus
```

Next clone this project :

```
git clone git@github.com:valterhenrique/simple-sinatra-app.git
cd devops && vagrant up
```

Next, you can check at your host machine the following address: http://localhost:8888



[system-requirements]: https://www.virtualbox.org/wiki/End-user_documentation
[download-virtualbox]: https://www.virtualbox.org/wiki/Downloads
[download-vagrant]: https://www.vagrantup.com/downloads.html.
[download-packer]: https://www.packer.io/
[chef-solo-provisioner]: https://www.vagrantup.com/docs/provisioning/chef_solo.html
[vagrant]: https://www.vagrantup.com/docs/
[virtualbox]: https://www.virtualbox.org/
