#######################################################
# Class: elasticsearch::package
#
class elasticsearch::package inherits elasticsearch::params {
    $file = "/tmp/elasticsearch-${elasticsearch::version}.deb"

    download { $file:
    uri => "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${elasticsearch::version}.deb"
    }

    package {
        'elasticsearch':
            require => Download[$file],
            name   => $elasticsearch::package,
            provider=> 'dpkg',
            source => $file
    }
}

define download ($uri, $timeout = 300) {

  package { 'wget':
    ensure => 'present'
  }

  exec {
    "download $uri":
        command => "/usr/bin/wget -q '$uri' -O $name",
        creates => "$name",
        timeout => $timeout,
        require => Package[ "wget" ],
  }
}