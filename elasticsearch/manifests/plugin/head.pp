#######################################################
# Class: elasticsearch::plugin::head
#
class elasticsearch::plugin::head inherits elasticsearch::params {
    exec {'install-plugin-head':
        command => "${elasticsearch::params::bin_plugin} -install mobz/elasticsearch-head",
        creates  => "${elasticsearch::params::dir_plugins}/head";
    }
}
