# Mailserver mit Mailinglisten:
# Wir installieren Postfix als MTA und Mailman als Listensoftware.
# Es gibt keine Mailboxen für Einzelpersonen, bei Bedarf
# (Pressearbeit,etc) Weiterleitungen.

class role::community::mailserver {
  include ::profile::community::postfix
  include ::profile::community::mailman
}
