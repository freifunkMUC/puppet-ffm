# Gitlab: Wir installieren zur besseren Koordination mit der weltweiten
# Community einen Gitlab-Server, der prinzipiell öffentlich einsehbar ist,
# und User-Accounts unterstützt. Secrets für Puppet-Deployment machen wir
# vmtl. mit https://github.com/StackExchange/blackbox

class role::community::gitlabserver {
  include ::profile::community::gitlab
}
