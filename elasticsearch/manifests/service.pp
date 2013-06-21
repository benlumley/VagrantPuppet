#######################################################
# Class: elasticsearch::service
#
class elasticsearch::service inherits elasticsearch::params {
    service {
        'elasticsearch':
            name   => $elasticsearch::service,
            ensure => $elasticsearch::running;
    }
}
