# sous_chef

Description
===========
Installs and configures a Jenkins server for cookbook testing. Additionally will create jobs
for cookbook testing based on an attribute driven system.

This service sets up a server with cookbook testing in mind. This includes configuring the ruby
environment and installing any needed gems to get off the ground running bundle etc... Lastly the
cookbook will configure and setup git and any ssh keys needed to communicate with the git server.

Requirements
============

This cookbook depends on several other cookbooks to accomplish the task of configuring a jenkins server to test cookbooks.

* 'jenkins'
* 'git'
* 'build-essential'
* 'rvm'
* 'apt'

Platforms
---------
* Ubuntu

Testing
-------
This cookbook is tested with rubocop, foodcritic and test-kitchen.  
Run `bundle install` to install required gems.

* rubocop
* foodcritic .
* kitchen test

Tested on:

* Ubuntu 14.04

Usage
=====

The chub\_sous\_chef cookbook will setup a jenkins server with the focus on cookbook testing. Many of the recipes are
designed to only be included in other recipes, these are noted by starting with underscore('_').

This cookbook by default will setup a job per cookbook.  These jobs will be broken into several steps as part of a cookbook testing pipeline. These steps include:

* bundle install
* rubocop
* foodcritic
* test_kitchen
* upload_cookbook

This cookbook stresses convention > configuration.  This means that there is a default job structure and defaults for
many of the configuration options.  These defaults are designed to be sane and reasonable with the ability to override  as needed.  Keep in mind this cookbook makes assumptions on how the steps should execute and run by default.  The default  setup for each cookbook job can be found in the default['sous_chef']['default_cookbook'] attribute or also below  in the attribute section of this readme.

Recipes
-------

* \_base - This recipe includes pre-req and shared requirements for jenkins servers both master and slave.
* \_cookbook_job - The recipe to setup a job for cookbook testing
* \_plugins - The recipe which contains plugin installations and configuration
* default - The recipe that does nothing. Don't use it.
* server - The recipe which sets up a jenkins master instance.

Role File Examples
------------------
In the below examples any and all combinations of attributes are supported.  Each cookbook will be merged with the
default cookbook. Feel free to only provide one attribute in a hash if you are only changing that attribute.  You
can refer to the ```default['sous_chef']['default_cookbook']``` attribute for all possible configurable options.

#### Setup the jenkins cookbook testing server with all defaults

```ruby
run_list *%w[
recipe[sous_chef::server]
]

default_attributes({})
```

#### Bare Bones: Configure a cookbook to leverage the service with all defaults

```ruby
default_attributes(
sous_chef: {
  cookbooks: [
    {
      cookbook_name: 'sous_chef',
      cookbook_url: 'git@git.nexus.commercehub.com:chef/sous_chef.git',
      notification: {
        email: {
          maintainers_email: 'myemail@commercehub.com'
        },
      }
    }
  ]
})
```

#### Hipchat Notification: Configure a cookbook to leverage the hipchat notification plugin

```ruby
default_attributes(
sous_chef: {
  cookbooks: [
    {
      cookbook_name: 'sous_chef',
      cookbook_url: 'git@git.nexus.commercehub.com:chef/sous_chef.git',
      notification: {
        email: {
          maintainers_email: 'lzarou@commercehub.com'
        },
        hipchat: {
          enabled: true,
          hipchat_room: 'Chef'
        }
      }
    }
  ]
})
```

#### Triggers: Change how often a job polls SCM

```ruby
default_attributes(
    sous_chef: {
        cookbooks: [
        {
            cookbook_name: 'sous_chef',
            cookbook_url: 'git@git.nexus.commercehub.com:chef/sous_chef.git',
            triggers: {
                poll_scm: {
                    schedule: '*/5 * * * *'
                }
            }
        }
        ]
    }
)
```

#### Custom Job Definition: Not happy with defaults? Customize the job definition for any given job

```ruby
default_attributes(
sous_chef: {
  cookbooks: [
    {
      cookbook_name: 'sous_chef',
      cookbook_url: 'git@git.nexus.commercehub.com:chef/sous_chef.git',
      notification: {
        email: {
          maintainers_email: 'lzarou@commercehub.com'
        },
      },
      steps: {
        foodcritic: {
          enabled: true,
          command: 'bundle exec foodcritic . -f correctness',
        }
      }
    }
  ]
})
```

Attributes
==========

Below is the definition of the default cookbook attribute.  This is the base for the job and steps being setup.  This allows convention > configuration with minimal configuration.

```ruby
default['sous_chef']['default_cookbook'] =
{
    cookbook_name: 'cookbook_name',
    cookbook_url: 'cookbook_url',
    notification: {
      email: {
        enabled: true,
        maintainers_email: 'noreply@commercehub.com'
      },
      hipchat: {
        enabled: false,
        hipchat_room: 'Chef',
        notifyStarted: false,
        notifySuccess: true,
        notifyAborted: true,
        notifyNotBuilt: false,
        notifyUnstable: true,
        notifyFailure: true,
        notifyBackToNormal: true
      }
    },
    triggers: {
      poll_scm: {
        enabled: true,
        schedule: '*/1 * * * *'
      }
    },
    steps: {
      bundle: {
        enabled: true,
        command: 'bundle install --path vendor/bundle'
      },
      foodcritic: {
        enabled: true,
        command: 'bundle exec foodcritic . -f any'
      },
      rubocop: {
        enabled: true,
        command: 'bundle exec rubocop'
      },
      test_kitchen: {
        enabled: true,
        command: 'bundle exec kitchen test',
      },
      upload_cookbook: {
        enabled: true,
        command: 'thor version:bump patch
        rm -rf replace_with_cookbook
        rsync -avz . ./replace_with_cookbook --exclude replace_with_cookbook
        knife cookbook upload replace_with_cookbook --cookbook-path . --freeze',
      }
    }
}
```

License and Author
==================

Author:: [Larry Zarou](<lzarou@commercehub.com>)  
Author\_Website:: [www.commercehub.com](www.commercehub.com)  
Twitter:: [@zarrylarou ](http://twitter.com/zarrylarou)  
IRC:: zarry on freenode  

Copyright 2015, Larry Zarou

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and