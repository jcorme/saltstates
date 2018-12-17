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

nfs_enable_rpcbind:
  sysrc.managed:
    - name: rpcbind_enable
    - value: YES

nfs_set_mountd_flag:
  sysrc.managed:
    - name: mountd_flags
    - value: '-r'

nfs_enable_server:
  sysrc.managed:
    - name: nfs_server_enable
    - value: YES

  service.running:
    - name: nfsd
