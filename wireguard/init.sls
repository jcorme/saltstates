{% if 'wireguard' in pillar %}
include:
  - epel

add_wireguard_repo:
  file.managed:
    - name: /etc/yum.repos.d/wireguard.repo
    - source: 'https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo'
    - source_hash: 'sha256=4794288ec48a49efedc10711d2eb3839a93427eed0e06e1ab91cf25a62bece38'
    - user: root
    - group: root
    - mode: 0644

install_wireguard_dkms:
  pkg.installed:
    - name: wireguard-dkms
    - require:
      - pkg: epel_release

install_wireguard_tools:
  pkg.installed:
    - name: wireguard-tools
    - requires:
      - pkg: wireguard-dkms
      - pkg: epel_release

{% for server in salt['pillar.get']('wireguard:tunnels:servers', []) %}
salt_firewall_listen_port_{{ server.listenport }}:
  firewalld.present:
    - name: public
    - prune_ports: False
    - prune_services: False
    - ports:
      - {{ server.listenport }}/udp

add_server_wg_interface_conf_{{ server.name }}:
  file.managed:
    - name: /etc/wireguard/{{ server.name }}.conf
    - source: salt://{{ slspath }}/templates/server.conf
    - user: root
    - group: root
    - mode: 0600
    - template: jinja
    - context:
        ifc: {{ server }}
{% endfor %}

{% for client in salt['pillar.get']('wireguard:tunnels:clients', []) %}
add_client_wg_interface_conf_{{ client.name }}:
  file.managed:
    - name: /etc/wireguard/{{ client.name }}.conf
    - source: salt://{{ slspath }}/templates/client.conf
    - user: root
    - group: root
    - mode: 0600
    - template: jinja
    - context:
        ifc: {{ client }}
{% endfor %}

{% for server in salt['pillar.get']('wireguard:tunnels:servers', []) %}
start_server_wg_quick_{{ server.name }}:
  service.running:
    - name: wg-quick@{{ server.name }}
    - enable: True
    - reload: True
    - require:
      - file: /etc/wireguard/{{ server.name }}.conf
{% endfor %}

{% for client in salt['pillar.get']('wireguard:tunnels:clients', []) %}
start_client_wg_quick_{{ client.name }}:
  service.running:
    - name: wg-quick@{{ client.name }}
    - enable: True
    - reload: True
    - require:
      - file: /etc/wireguard/{{ client.name }}.conf
{% endfor %}
{% endif %}
