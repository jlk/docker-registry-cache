# docker-registry-cache
Vagrant/virtualbox setup to provide local docker image cache.

## Use
In it's most basic form:

```
git clone git@github.com:jlk/docker-registry-cache.git
cd docker-registry-cache
vagrant up
```

At this point you should be able to hit http://192.168.99.50:5000/v2/ and see something similar to:
```
{}
```
At this point, configure your docker setup to use the cache.

#### Docker-machine
To use the cache with `docker-machine`, pass the `--engine-registry-mirror` option when running docker-machine create:
```
docker-machine create -d virtualbox --engine-registry-mirror=http://192.168.99.50:5000 new-awesomeness
```

(more examples will probably come in time)

## Configuration
#### Network
By default, this will spin up a copy of [williamyeh/ubuntu-trusty64-docker] (https://atlas.hashicorp.com/williamyeh/boxes/ubuntu-trusty64-docker)
and then download/run version 2 of Docker's registry. A host-only network interface is added at 192.168.99.50.
The 192.168.99.0/24 network is the same used by docker-machine by default. That IP address is specified in [Vagrantfile](https://github.com/jlk/docker-registry-cache/blob/master/Vagrantfile):
```
  config.vm.network "private_network", ip: "192.168.99.50", virtualbox__intnet: false
```

#### Storage
This setup is configured to use Vagrant's default shared directory concept of putting the current directory at `/vagrant`
in the VM. The provisioning script then instructs the registry container to use /vagrant/data as it's datastore. This means if you destroy and recreate the container, the cache will survive. If you want to completely erase the cache, while the VM is down, run

```
rm -r data/docker data/scheduler-state.json
```

Alternately, it's probably possible to configure Vagrant to have a different source for the /vagrant share and in turn the 
cache datastore. Doing so is left as an experiment for the reader, but remember if you go down this path, the container is 
looking for it's config at /vagrant/config.yml.

#### Specifying Docker Hub user
The Docker instructions at the bottom of this readme show how to specify a username and password so the cache can access your 
private images at Docker Hub. If you go down this path, keep security in mind. I haven't attempted to access this proxy yet 
from anything other than my local machine....my belief is it should be unaccessable as Vagrant configures VirtualBox to use 
a host-only network, but I have not verified this yet.

## Extras
The williamyeh/ubuntu-trusty64-docker Vagrant box starts with Google's [cAdvisor](https://github.com/google/cadvisor)
running - you can access it at http://192.168.99.50:8080/containers/

Additionally, looks like the box comes with several other docker images already downloaded. YMMV.

## Potential future additions
Right now I'm leaving TLS out of the picture - the intention is for this to be used as a local cache for public images.
I can imagine adding some logic to the provisioning script to check for a TLS certificate, and if so use a version of 
the config file that configures TLS. 

## Suggestions/problems
I'm open to suggestions on how to improve this - I'm sure I haven't thought of all use cases yet. Pull requests or issues welcomed.
Alternately, reach out to me on Twitter at [@johnlkinsella](https://twitter.com/johnlkinsella).

## Credits
This is based off [Docker's instructions on how to build a proxy cache](https://blog.docker.com/2015/10/registry-proxy-cache-docker-open-source/).
