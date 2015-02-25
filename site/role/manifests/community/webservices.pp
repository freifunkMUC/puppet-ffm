# Webseite+Wiki+Etherpad: 
#   - Statische Seite mit jekyll (analog zur jetzigen)
#   - als Wiki-Software xwiki.
#   - Zusätzlich unter /pad/ eine Etherpad-Instanz ohne Benutzerverwaltung; 
#     14 Tage nach Erstellung eines Pads wird es von einem Cronjob
#     erbarmungslos gelöscht, um einen Anreiz zur Endlagerung von Inhalten
#     im durchsuchbaren Wiki zu bieten. Die Webseite bekommt ein anerkanntes
#     Premium-Zertifikat für 15$.

class role::community::webservices {
  include ::profile::community::website
  include ::profile::community::wiki
  include ::profile::community::etherpad
}
