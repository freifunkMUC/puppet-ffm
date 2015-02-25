# DNS: Wir installieren für die zu verwaltenden Zonen PowerDNS
# mit PowerAdmin als Webfrontend. PowerAdmin unterstützt LDAP-Authentifizierung.

class role::community::dnsserver {
  include ::profile::community::dns
}
