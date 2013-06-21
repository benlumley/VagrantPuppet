#######################################################
# Class: elasticsearch::config
#
class elasticsearch::config inherits elasticsearch::params {
    $clustername = $elasticsearch::clustername
    $node_master = true
    $node_data = true

    file {
        $elasticsearch::params::config_file:
            content => template('elasticsearch/elasticsearch.yml.erb'),
            require => Class['elasticsearch::package'];

        $elasticsearch::params::config_log:
            content => template('elasticsearch/logging.yml.erb'),
            require => Class['elasticsearch::package'];

#        $elasticsearch::params::dir_base:
#            ensure => directory,
#            owner => $elasticsearch::params::es_user,
#            group => $elasticsearch::params::es_group,
#            mode => 774,
#            recurse => true

    }

    case $::operatingsystem {
        'Debian': {
            file {
                '/etc/default/elasticsearch':
                    content => template('elasticsearch/debian-default-elasticsearch.erb'),
                    require => Class['elasticsearch::package'];
            }
        }
    }

    #    blau_commons::line {
    #        "elasticsearch_soft_nofile":
    #            file => "/etc/security/limits.conf",
    #            line => "elasticsearch soft nofile 32000";
    #    }
    #    blau_commons::line {
    #        "elasticsearch_hard_nofile":
    #            file => "/etc/security/limits.conf",
    #            line => "elasticsearch hard nofile 32000";
    #    }

}
