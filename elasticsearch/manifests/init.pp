# == Class: elasticsearch
#
# All default values are defined in the
# elasticsearch::params class.
#
# === Parameters
#
#   [*clustername*]
#       Name of elasticsearch Cluster
#
#   [*package*]
#       OS Package name
#
#   [*version*]
#       Elastic version to install
#
#   [*running*]
#       state of elasticsearch service
#
#
# === Examples
#
#   class{'elasticsearch': clustername => 'test'}
#
# === Author
#
# Dennis Konert <dkonert@gmail.com>
#
class elasticsearch (
    $clustername   = $elasticsearch::params::clustername,
    $package       = $elasticsearch::params::package,
    $version       = $elasticsearch::params::version,
    $heap_size     = $elasticsearch::params::heap_size,
    $running       = true
) inherits elasticsearch::params {
    class{'elasticsearch::package': }->
    class{'elasticsearch::config': }~>
    class{'elasticsearch::service': }->
    Class['elasticsearch']
}
