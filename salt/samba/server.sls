include:
  - samba

{% for user in salt['pillar.get']('samba:server:users', []) %}
samba_add_user_{{ user['name'] }}:
  pdbedit.managed:
    - name: {{ user['name'] }}
    - login: {{ user['name'] }}
    - password: |
        {{ user['password'] | indent(8) }}
    - password_hashed: False
{% endfor %}

samba_create_config:
  file.managed:
    - name: /etc/samba/smb.conf
    - source: salt://{{ slspath }}/templates/smb.conf
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
