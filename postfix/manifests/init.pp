class postfix {
  package { 'postfix':
    ensure => 'latest'
  }

  service { 'postfix':
    ensure => running,
    enable => true,
    require => Package['postfix'],
  }

}