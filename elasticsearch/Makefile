smoke: test

test:
	find tests -name \*.pp | xargs -n 1 -t puppet apply --noop --modulepath=tests/modules

vm:
	vagrant up

es_version = 0.18.7
es_tarchive = elasticsearch-$(es_version).tar.gz
es_source = http://cloud.github.com/downloads/elasticsearch/elasticsearch

fetch: files/$(es_tarchive)

files/$(es_tarchive):
	curl -o files/$(es_tarchive) $(es_source)/$(es_tarchive)
