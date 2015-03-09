
## sous_chef
default['sous_chef']['cookbooks'] = []
default['sous_chef']['merged_cookbooks'] = []

default['sous_chef']['default_cookbook'] =
    {
      cookbook_name: 'cookbook_name',
      cookbook_url: 'cookbook_url',
      notification: {
        email: {
          enabled: true,
          maintainers_email: 'email@address.com'
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
        rubocop: {
          enabled: true,
          command: 'bundle exec rubocop'
        },
        foodcritic: {
          enabled: true,
          command: 'bundle exec foodcritic . -f any'
        },
        test_kitchen: {
          enabled: true,
          command: 'bundle exec kitchen test
          rm -f Berksfile.lock'
        },
        upload_cookbook: {
          enabled: true,
          command: 'thor version:bump patch
          rsync -avzq . ./replace_with_cookbook --exclude replace_with_cookbook --exclude \'vendor\'
          knife cookbook upload replace_with_cookbook --cookbook-path . --freeze
          rm -rf replace_with_cookbook'
        }
      }
    }

# General sous_chef properties
default['sous_chef']['master_executors'] = 4

## Mailer Notifier
default['sous_chef']['smtp_host'] = 'yourmail.server.com'
default['sous_chef']['smtp_port'] = '25'
default['sous_chef']['smtp_reply_to_address'] = 'email@address.com'
default['sous_chef']['smtp_admin_address'] = 'email@address.com'
default['sous_chef']['smtp_email_suffix'] = '@address.com'

## Hipchat Notifier
default['sous_chef']['hipchat_auth_token'] = ''
default['sous_chef']['hipchat_send_as'] = 'Sous Chef'
default['sous_chef']['hipchat_server_url'] = 'yourhipchat.server.com'
default['sous_chef']['hipchat_build_server_url'] = "http://#{node['fqdn']}:8080/"
default['sous_chef']['hipchat_default_room'] = 'Chef'

## Jenkins Cookbook
default['jenkins']['master']['install_method'] = 'package'
default['jenkins']['master']['version'] = nil

## Gitlab Deploy Key Credentials
default['sous_chef']['gitlab_credential_id'] = '' 
default['sous_chef']['gitlab_public_key'] = ''

## Gitlab Service Account Credentials
default['sous_chef']['gitlab_service_account_key'] = ''


## Chef
default['sous_chef']['chef']['username'] = 'jenkins_cookbook'
default['sous_chef']['chef']['server_url'] = 'https://chef.server.url.com'
