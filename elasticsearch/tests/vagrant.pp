stage { pre: before => Stage[main] }

class apt_get_update {
  $sentinel = "/var/lib/apt/first-puppet-run"

  exec { "initial apt-get update":
    command => "/usr/bin/apt-get update && touch ${sentinel}",
    onlyif  => "/usr/bin/env test \\! -f ${sentinel} || /usr/bin/env test \\! -z \"$(find /etc/apt -type f -cnewer ${sentinel})\"",
    timeout => 3600,
  }
}

# If we don't run apt-get update, installing openjdk will fail.
class { 'apt_get_update':
  stage => pre,
}

group { 'puppet': 
  ensure => present,
  system => true,
}

class { 'elasticsearch':
}
