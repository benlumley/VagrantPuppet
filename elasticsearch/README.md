# Elasticsearch module for puppet

Debian only for now. You need to add the debian package from
http://www.elasticsearch.org/download/
to your local repository.

## Example usage
```
class {'elasticsearch': 
    clustername => 'ElasticCluster',
    version     => '0.19.10',
    package     => 'elasticsearch'
}
```

