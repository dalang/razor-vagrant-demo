razor-vagrant-demo
==================

# TODO
### Auto configurations failed
1. NPM for node.js
1. mime and express@2.5.11 packages of node.js (with --registry=registry.npm.taobao.org)
1. set agent1 network to host-only type **manually**

### Mongodb service cannot start
If it happens, `razor` will not work.
This always caused by VM not been shutdown gracefully.
Try the solution as follow.

* ssh to VM
* delete mongodb.lock file at /var/lib/mongodb/
* restart mongodb service

### Host OS is Windows
* **care line ending on Windows, it's recommended to run `git config --global core.autocrlf false`**
* puppet cannot work as a gem on windows, **install puppet by windows installer instead.** 
* `librarian-puppet` gem depends on `puppet` gem, so won't work under windows either. 
* Vagrant-wrapper not work proper on windows, use [dalang's fork](https://github.com/dalang/gem-vagrant-wrapper) instead.
* tftp service not running: `service tftpd-hpa restart`

***

A demo of Razor using Vagrant.

# Demo

This is a demo using Vagrant of [Puppet Lab's Razor
introduction](http://puppetlabs.com/blog/puppet-razor-module/).

## Step 1: Setup

First install VirtualBox and the VirtualBox Extension Pack. Next bundle
& boot the servers:

```
$ bundle install
$ bundle exec rake start
```

The `gold` server will boot first and kick off a puppet run. This will
install razor and setup dhcp on the internal VM network. Once the gold
server finished the `agent1` box will boot. `agent1` initially fails to
PXE boot because razor is not configured with a microkernel.

![MicroKernel Missing](images/microkernel_missing.png)

## Step 2: Register a MicroKernel

```
$ bundle exec rake microkernel
```

The `microkernel` rake task downloads and registers the razor microkernel.
At this point `agent1` will boot the microkernel.

![MicroKernel Console](images/microkernel_console.png)

The `agent1` server will register itself with razor. We can inspect it
via the `razor node` command.

```
$ bundle exec vagrant ssh gold
$ sudo su -
$ cd /opt/razor
$ bin/razor node
```

![razor node](images/razor_node.png)

The `razor node attributes` command will show the attributes of `agent1`.

```
$ bin/razor node attributes ...
```

![razor node attributes](images/razor_node_attributes.png)

## Step 3: Register an OS

Run the `ubuntu` rake task to download and register Ubuntu Precise 12.04
Server with razor. This may take a while.

```
$ bundle exec rake ubuntu
```

List the registered OS images via `razor image`.

```
$ bundle exec vagrant ssh gold
$ sudo su -
$ cd /opt/razor
$ bin/razor image
```

![razor image](images/razor_image.png)

## Step 4: Create a Model

Add a model for `ubuntu\_precise` with the new image.

```
$ bin/razor model add template=ubuntu_precise label=install_precise image_uuid=...
```

![razor model add](images/razor_model_add.png)

## Step 5: Add a Policy

Create a policy to install ubuntu on `agent1`.

```
$ bin/razor policy add --template=linux_deploy --label=precise --broker-uuid=none --tags=virtualbox_vm --enabled --model-uuid=...
```

![razor policy add](images/razor_policy_add.png)

## Step 6: Ubuntu

On the next checkin by `agent1` the server will reboot. Instead of booting
the microkernel, razor serves `agent1` the Ubuntu installer.

![Ubuntu Installer](images/ubuntu_installer.png)

Once that finishes you can login as root with your password.

![Ubuntu Console](images/ubuntu_console.png)

## Step 7: Cleanup

Run `vagrant destroy` to cleanup everything.

```
$ bundle exec vagrant destroy --force
```
