# Only supports FreeBSD

{% if salt['pillar.get']('nfs:exports', []) | length > 0 %}

nfs_create_exports:
  file.managed:
    - name: /etc/exports
    - source: salt://{{ slspath }}/templates/exports
    - user: root
    - group: wheel
    - mode: 0644
    - template: jinja

nfs_enable_rpcbind:
  sysrc.managed:
    - name: rpcbind_enable
    - value: YES

nfs_set_mountd_flag:
  sysrc.managed:
    - name: mountd_flags
    - value: '-r'

nfs_enable_v4_server:
  sysrc.managed:
    - name: nfsv4_server_enable
    - value: YES

nfs_enable_server:
  sysrc.managed:
    - name: nfs_server_enable
    - value: YES

  service.running:
    - name: nfsd

nfs_reload_mountd:
  service.running:
    - name: mountd
    - reload: True
    - watch:
      - file: nfs_create_exports

{% endif %}
