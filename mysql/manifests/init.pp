# mysql.pp
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class mysql {

	package { [ "mysql-server", 'mysql-client', 'php5-mysql' ]:
		ensure => installed,
	}

	service { mysql:
		ensure => running,
		hasstatus => true,
		require => Package["mysql-server"],
	}

  file { '/etc/mysql/my.cnf':
    source => 'puppet:///modules/mysql/my.cnf',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
		require => [ Package[ "mysql-server" ], Package[ "mysql-client" ] ],
    notify  => Service[ "mysql" ]
  }

  # some mysql versions like to make a test db. I DO NOT WANT THAT
  exec { "remove test db":
    require => [ Package[ "mysql-server" ], Package[ "mysql-client" ] ],
    onlyif => "/usr/bin/mysql -u root -e 'use test'",
    command => "/usr/bin/mysql -u root -e 'DROP DATABASE test'",
  }

  define database ( ) {
    exec { "Add database ($name)":
      require => [ Package[ "mysql-server" ], Package[ "mysql-client" ] ],
      unless => "/usr/bin/mysql -u root -e 'use $name'",
      command => "/usr/bin/mysql -u root -e 'CREATE DATABASE $name'",
    }
  }

  define user (
    $database,
    $password,
    $privilege = 'all',
    $host = 'localhost'
  ) {
    exec { "Add User ($name) To A Database":
      require => [ Package[ "mysql-server" ], Package[ "mysql-client" ] ],
      unless  => "/usr/bin/mysql -u $name -p'$password' $database -e 'show status;'",
      command => "/usr/bin/mysql -u root -e \"GRANT ALL ON $database.* TO '$name'@'$host' IDENTIFIED BY '$password'; FLUSH PRIVILEGES;\"",
      notify  => Service[ "mysql" ]
    }
  }

}
