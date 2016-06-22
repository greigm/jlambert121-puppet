# document me
class puppet::server::install (
  $puppetdb         = $::puppet::puppetdb,
  $puppetdb_version = $::puppet::puppetdb_version,
  $manage_puppetdb  = $::puppet::manage_puppetdb,
  $server           = $::puppet::server,
  $server_version   = $::puppet::server_version,
) {

  $_server_version = $server ? {
    true    => $server_version,
    default => 'absent'
  }

  if $server {
    $_puppetdb_version = $puppetdb ? {
      true    => $puppetdb_version,
      default => 'absent'
    }
  } else {
    $_puppetdb_version = 'absent'
  }

  package { 'puppetserver':
    ensure => $_server_version,
  }

  if ($server and $puppetdb and $manage_puppetdb) {
    package { 'puppetdb-termini':
      ensure => $_puppetdb_version,
    }
  }

  if $server {
    # Set up environments
    file { '/etc/puppetlabs/code/environments':
      ensure => 'directory',
      mode   => '0755',
      owner  => $::settings::user,
      group  => $::settings::group,
    }

    file { '/opt/puppetlabs/puppet/cache/r10k':
      ensure => directory,
      owner  => $::settings::user,
      group  => $::settings::group,
    }
  }
}
