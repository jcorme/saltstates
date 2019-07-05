install_avahi_daemon:
  pkg.installed:
    - name: avahi

  service.running:
    - name: avahi-daemon
    - enable: True
    - require:
      - pkg: avahi

avahi_firewall_rule:
  firewalld.present:
    - name: public
    - prune_services: False
    - services:
      - mdns
