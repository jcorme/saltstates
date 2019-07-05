{% for repo in salt['pillar.get']('repos:freebsd', []) %}
create_freebsd_repo_{{ repo.name }}:
  file.managed:
    - name: /usr/local/etc/pkg/repos/{{ repo.name | lower }}.conf
    - source: salt://{{ slspath }}/templates/freebsd_repo.conf
    - user: root
    - group: wheel
    - mode: 0644
    - makedirs: True
    - template: jinja
    - context:
        repo: {{ repo }}

{% if 'create_pubkey_contents' in repo %}
create_freebsd_repo_{{ repo.name }}_key_file:
  file.managed:
    - name: {{ repo.pubkey_location }}
    - user: root
    - group: wheel
    - mode: 0600
    - dir_mode: 0700
    - makedirs: True
    - contents: |
        {{ repo.create_pubkey_contents | indent(8) }}
{% endif %}
{% endfor %}

update_freebsd_repo:
  cmd.run:
    - name: pkg update
    - runas: root
    - use_vt: True
