{% for mount in salt['pillar.get']('nfs:mounts', []) %}
nfs_mount_{{ mount.mount_point | replace ('/', '-')}}:
  mount.mounted:
    - name: {{ mount.mount_point }}
    - device: {{ mount.folder }}
    - fstype: nfs
    - persist: True
    - mount: True
    - mkmnt: True
    {% if 'opts' in mount %}
    - opts:
      {% for opt in mount.opts %}
      - {{ opt }}
      {% endfor %}
    {% endif %}
{% endfor %}
