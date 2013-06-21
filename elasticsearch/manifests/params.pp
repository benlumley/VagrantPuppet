#######################################################
# Class: elasticsearch::params
#
# Default values for elasticsearch installations
#
class elasticsearch::params {
    $clustername = 'ElasticCluster'
    $version     = '0.20.3'

    # run as user / group
    $es_user     = 'elasticsearch'
    $es_group    = 'elasticsearch'

    # default heap-size
    $heap_size   = '256m'


    case $::operatingsystem {
        'Debian': {
            $package     = 'elasticsearch'
            $service     = 'elasticsearch'
            $config_dir  = '/etc/elasticsearch'
            $config_file = "${conf_dir}/elasticsearch.yml"
            $config_log  = "${conf_dir}/logging.yml"
            $dir_base    = '/usr/share/elasticsearch'
            $dir_plugins = "${dir_base}/plugins"
            $bin_plugin  = "${dir_base}/bin/plugin"
        }
        default: {
            fail("sorry, I don't know how to support ${::operatingsystem}")
        }
    }
}
