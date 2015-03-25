# Creates and curates a hubot user
class hubotuser (
  $public_ssh_key_string,
  $sudo_rules_string
) {
  # Create the hubot user
  user {
    'hubot_user':
      name           => 'hubot',
      ensure         => 'present',
      managehome     => 'true',
      home           => '/home/hubot',
      shell          => '/bin/bash',
      purge_ssh_keys => 'true';
  }

  # Populate authorized keys file
  ssh_authorized_key {
    'hubot_access_key':
      user    => 'hubot',
      ensure  => 'present',
      type    => 'ssh-dss',
      key     => $public_ssh_key_string,
      require => User['hubot']
  }

  # Create sudoers file from template
  file {
    '/etc/sudoers.d/hubot':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => inline_template("<%= @sudo_rules_string %>");
  }
}

# vim: set shiftwidth=2 softtabstop=2 textwidth=0 wrapmargin=0 syntax=ruby:
