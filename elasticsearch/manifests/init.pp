class elasticsearch::params {
  $version = "0.19.8"
  $java_package = "openjdk-6-jre-headless"
  $dbdir = "/var/lib/elasticsearch"
  $logdir = "/var/log/elasticsearch"
}

class elasticsearch(
  $version = $elasticsearch::params::version,
  $java_package = $elasticsearch::params::java_package,
  $dbdir = $elasticsearch::params::dbdir,
  $logdir = $elasticsearch::params::logdir
) inherits elasticsearch::params {
  $tarchive = "elasticsearch-${version}.tar.gz"
  $tmptarchive = "/tmp/${tarchive}"
  $tmpdir = "/tmp/elasticsearch-${version}"
  $sharedirv = "/usr/share/elasticsearch-${version}"
  $sharedir = "/usr/share/elasticsearch"
  $etcdir = "/etc/elasticsearch"
  $initscript = "/etc/init.d/elasticsearch"
  $defaultsfile = "/etc/default/elasticsearch"
  $configfile = "$etcdir/elasticsearch.yml"
  $logconfigfile = "$etcdir/logging.yml"

  Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

  if !defined(Package[$java_package]) {
    package { $java_package:
      ensure => installed,
    }
  }

  if !defined(Package['wget']) {
    package { 'wget':
      ensure => installed,
    }
  }

  File {
    before => Service['elasticsearch'],
  }

  group { 'elasticsearch':
    ensure => present,
    system  => true,
  }

  user { 'elasticsearch':
    ensure  => present,
    system  => true,
    home    => $sharedir,
    shell   => '/bin/false',
    gid     => 'elasticsearch',
    require => Group['elasticsearch'],
  }

  file { $dbdir:
    ensure  => directory,
    owner   => 'elasticsearch',
    group   => 'elasticsearch',
    mode    => '0755',
    require => User['elasticsearch'],
  }

  file { $logdir:
    ensure  => directory,
    owner   => 'elasticsearch',
    group   => 'elasticsearch',
    mode    => '0755',
    require => User['elasticsearch'],
  }

  download { $tmptarchive:
    uri     => "https://github.com/downloads/elasticsearch/elasticsearch/${tarchive}"
  }

  exec { $tmpdir:
    command => "/bin/tar xzf ${tmptarchive}",
    cwd     => "/tmp",
    creates => $tmpdir,
    require => Download[$tmptarchive],
  }

  exec { $sharedirv:
    command => "find . -type f | xargs -i{} install -D {} ${sharedirv}/{}",
    cwd     => $tmpdir,
    path    => "/bin:/usr/bin",
    creates => $sharedirv,
    require => Exec[$tmpdir],
  }

  file { $sharedir:
    ensure  => link,
    target  => $sharedirv,
    require => Exec[$sharedirv],
  }

  file { "$sharedir/elasticsearch.in.sh":
    ensure  => link,
    target  => "$sharedir/bin/elasticsearch.in.sh",
    require => File[$sharedir],
  }

  file { "/usr/bin/elasticsearch":
    ensure => link,
    target => "$sharedirv/bin/elasticsearch",
    require => Exec[$sharedirv],
  }

  file { $etcdir:
    ensure => directory
  }

  file { $configfile:
    ensure => present,
    source => ["puppet:///files/site-elasticsearch/${fqdn}/elasticsearch.yml",
               "puppet:///files/site-elasticsearch/elasticsearch.yml",
               "puppet:///modules/elasticsearch/elasticsearch.yml"],
    owner  => root,
    group  => root,
  }

  file { $logconfigfile:
    ensure => present,
    source => ["puppet:///files/site-elasticsearch/${fqdn}/logging.yml",
               "puppet:///files/site-elasticsearch/logging.yml",
               "puppet:///modules/elasticsearch/logging.yml"],
    owner  => root,
    group  => root,
  }

  file { $defaultsfile:
    ensure => present,
    source => "puppet:///modules/elasticsearch/etc-default-elasticsearch",
  }

  file { $initscript:
    ensure => present,
    owner => root,
    group => root,
    mode => 0755,
    source => "puppet:///modules/elasticsearch/initd-elasticsearch",
  }

  service { 'elasticsearch':
    ensure   => running, 
    enable   => true,
    require  => File[$initscript]
  }
}

define download ($uri, $timeout = 300) {
  exec {
    "download $uri":
        command => "wget -q '$uri' -O $name",
        creates => "$name",
        timeout => $timeout,
        require => Package[ "wget" ],
  }
}
