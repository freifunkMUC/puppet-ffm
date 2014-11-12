### FFM Puppet Repo

Bisher nur ein Skelett für ein Gateway Puppet-Repo um mal das Eis zu brechen was puppet betrifft.

## Nutzung

in den ''modules'' Ordner können puppetforge module installiert werden.

```
puppet module install --modulepath=./modules foobar
```

im module ''ffm'' liegen die roles + profiles, nach dem bekannten Pattern. Für uns wird es wohl nur eine Rolle geben die, ffm::roles::freifunk_gateway, aber es schadet nicht, das ganze gleich gescheit aufzuziehen.

Profiles sind einzelne Funktionalitäten die man aus puppetforge modulen oder eigens geschriebenen modulen zusammen baut.

## Hiera

Hiera macht es einfach möglich Daten von den Modulen zu trennen. So kann man ipadressen, etc. also alles was Server spezifisch ist dort pflegen. Hierzu einfach bei der Profiles Klasse die ein Variable benötigt eine Klassenvariable anlegen z.B.:

```
class ffm::profiles::gateway_networking( $ipaddress ) {
...
```

Diese kann dann im Nodespezifischen Hiera-Config überschrieben werden. File anlegen: nodes/meinhostname.yaml

```
---
ffm::profiles::gateway_networking::ipaddress: '123.123.123.123'
```

So kann man einfach die Module für x gateways nutzen.


### Ausführen/Testing

Einen Testlauf, der noch nichts ausführt kann man mit 

```
./test_apply.sh
```

ausführen. So sollten Fehler etc. auffallen.

mit 

```
./apply.sh
```

kann man dann die Manifeste wirklich ausführen.


