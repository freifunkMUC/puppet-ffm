# LDAP: Wir installieren einen OpenLDAP-Server 
# der über authentifizierte SSH-Tunnel von den
# anderen Services nutzbar ist.

class role::community::ldapserver {
  include ::profile::community::ldap
}
