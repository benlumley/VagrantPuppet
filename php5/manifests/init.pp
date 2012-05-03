# Class: php5-fpm
#
# This class manage php5-fpm installation and configuration. 
# Config file 'php5-fpm.conf' is very minimal : only include /etc/php5/fpm/fpm.d/*.conf
# Use php5-fpm::config for configuring php5-fpm 
#
# Templates:
#	- php5-fpm.conf.erb
#
class php5 {

	package { [ php5-fpm, php5-cli, php5-xdebug, php5-gd, php5-curl, php5-memcached, php5-memcache, php5-intl, php5-sqlite ]: 
		ensure => installed,
		notify => Exec["reload-php5-fpm"],
	}

	service { php5-fpm:
		ensure => running,
		enable => true,
		require => File["/etc/php5/fpm/php5-fpm.conf"],
	}

	file{"/etc/php5/fpm/php5-fpm.conf":
		ensure => present,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content => template("php5/php5-fpm.conf.erb"),
		require => Package["php5-fpm"],
		notify => Exec["reload-php5-fpm"],
	}

	file{"/etc/php5/fpm/fpm.d":
		ensure => directory,
		checksum => mtime,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require => Package["php5-fpm"],
	}

	file { "/etc/php5/fpm/pool.d":
		ensure => directory,
		checksum => mtime,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require => Package["php5-fpm"],
		purge => true,
		recurse => true
	}

	exec{"reload-php5-fpm":
		command => "/etc/init.d/php5-fpm restart",
    refreshonly => true,
		require => File["/etc/php5/fpm/php5-fpm.conf"],
  }

  class apc {
  	package { "php5-apc": 
  		ensure => present,
  		notify => Exec["reload-php5-fpm"]
  	}
  }

	# Define : php5-fpm::config
	#
	# Define a php-fpm config snippet. Places all config snippets into
	# /etc/php5/fpm/fpm.d, where they will be automatically loaded
	#
	# Parameters :
	#	* ensure: typically set to "present" or "absent".  Defaults to "present"
	#	* content: set the content of the config snipppet.  Defaults to	'template("php5-fpm/fpm.d/$name.conf.erb")'
	#	* order: specifies the load order for this config snippet.  Defaults to "500"
	#
	# Sample Usage:
	# 	php5-fpm::config{"global":
	#		ensure	=> present,
	#		order	=> "000",
	#	}
	#	php5-fpm::config{"www-example-pool":
	#		ensure	=> present,
	#		content	=> template("php5-fpm/fpm.d/www-pool.conf.erb"),
	#	}
	#	

	php5::config { 'dev': }

  define fpmconfig ( $ensure = 'present', $content = '', $order="500") {
		$real_content = $content ? { 
			'' => template("php5/fpm.d/${name}.conf.erb"),
  		default => $content,
	  }

		file { "/etc/php5/fpm/fpm.d/${order}-${name}.conf":
			ensure => $ensure,
			content => $real_content,
			mode => 644,
			owner => root,
			group => root,
			notify => Exec["reload-php5-fpm"],
			before => Service["php5-fpm"],
		}
  }

  define config ( $ensure = 'present', $content = '', $order="500") {
		$real_content = $content ? { 
			'' => template("php5/conf.d/${name}.ini.erb"),
  		default => $content,
	  }

		file { "/etc/php5/conf.d/${order}-${name}.ini":
			ensure => $ensure,
			content => $real_content,
			mode => 644,
			owner => root,
			group => root,
			notify => Exec["reload-php5-fpm"],
			before => Service["php5-fpm"],
		}
  }

  define fpmpool( $ensure = 'present', $port = 9000 ) {
		file { "/etc/php5/fpm/pool.d/${name}.conf":
			ensure => $ensure,
			content => template('php5/pool.d/pool.conf.erb'),
			mode => 644,
			owner => root,
			group => root,
			notify => Exec["reload-php5-fpm"],
			before => Service["php5-fpm"],
		}
  }

}


