{% for export in salt['pillar.get']('nfs:exports', []) %}
add_export_{{ export.name | replace('/', '-') }}:
  nfs_export.present:
    - name: {{ export.name }}
    - hosts: {{ export.hosts }}
    - options:
      {% for opt in export.options %}
      - {{ opt }}
      {% endfor %}
{% endfor %}

nfs_server_config:
  sysrc.managed:
    - name: rpcbind_enable
    - value: YES

  sysrc.managed:
    - name: nfs_server_enable
    - value: YES

  sysrc.managed:
    - name: mountd_flags
    - value: '-r'

  service.running:
    - name: nfsd
