{% for ifc in salt['pillar.get']('host:mlxcfg:interfaces', []) %}
/etc/sysconfig/network-scripts/ifcfg-{{ ifc['name'] }}:
  file.managed:
    - source: salt://{{ slspath }}/templates/ifcfg-ifc
    - user: root
    - group: root
    - mode: 0600
    - template: jinja
    - context:
        interface: {{ ifc['name'] }}
        ip: {{ ifc['ip'] }}

{% if ifc.get('max_txqueuelen', False) %}
/etc/udev/rules.d/60-custom-txqueuelen-{{ ifc['name'] }}.rules:
  file.managed:
    - source: salt://{{ slspath }}/templates/txqueuelen.rules
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
        interface: {{ ifc['name'] }}
{% endif %}
{% endfor %}
