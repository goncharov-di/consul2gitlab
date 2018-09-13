# consul2gitlab
Simple script to store history of Consul KV values to git repository in GitLab

## Variables used in script
`CONSUL_HOST=http://example1.com:8500` - Consul address to get history

`GITLAB_HOST=http://example2.com` - Gitlab address to store history

`TOKEN=aaaaaaaaaaaaaaaaaaaa` - token to update repo Gitlab

`PROJ=test%2Fconsul-history` - Group (test) and name (consul-history) of the project in Gitlab where history of values will be stored.

`FILE=history` - Filename in repo to store history
