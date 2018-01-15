ROLE_NAME=File.basename(Dir.pwd)
ENV['ANSIBLE_NOCOWS'] = '1'

vagrant_command = ARGV[0]
if [ 'up', 'provision' ].include? vagrant_command
  unless ENV['VIRTUAL_ENV']
    puts "Not in virtual environment. Run 'make vagrant_#{vagrant_command} instead"
    abort
  end
end

# To add forwarded ports - simply create an array of hashes as follows
#    forwarded_ports = [{ guest: 8080, host: 11080 }, { guest: 8081, host: 11081}]
# Which will forward the ports on Vagrantbox 8080/8081 to local box 11080/11081
forwarded_ports = []

name = File.basename(Dir.pwd)
ram = ENV['ANSIBLE_ROLE_RAM'] || '1536'
# Must be specified as an environment value as is not a provisioner option
ENV['ANSIBLE_ROLES_PATH'] = File.join(Dir.pwd, "tests", "roles")

Vagrant.configure("2") do |config|
  config.vm.define name do |conf|
    conf.vm.box = "centos/7"
    conf.vm.hostname = "#{name}.tester.vagrant.local"

    # Centos/7 box has default rsync enabled in its Vagrantfile so manually disabling here - see: https://github.com/hashicorp/vagrant/issues/6154
    conf.vm.synced_folder '.', '/vagrant', disabled: true 

    conf.vm.provider "virtualbox" do |vb|
      vb.name = name
      vb.customize ['modifyvm', :id, '--memory', ram]
    end

    forwarded_ports.each do |port|
      conf.vm.network "forwarded_port", guest: port[:guest], host: port[:host]
    end

    conf.vm.provision :shell, inline: "cat /etc/redhat-release"
    conf.vm.provision "ansible" do |ansible|
      ansible.playbook = "tests/test.yml"
      ansible.inventory_path = "tests/inventory/vagrant.sh"
      ansible.limit = "all"
      ansible.config_file = "tests/ansible.cfg"
    end
  end
end
