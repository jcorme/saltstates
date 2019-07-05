include:
  - samba
  - avahi

{% for user in salt['pillar.get']('samba:server:users', []) %}
samba_add_user_{{ user['name'] }}:
  pdbedit.managed:
    - name: {{ user['name'] }}
    - login: {{ user['name'] }}
    - password: {{ user['password'] }}
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

samba_firewalld_config:
  firewalld.present:
    - name: public
    - prune_services: False
    - services:
      - samba

{% for root in salt['pillar.get']('samba:server:selinux_roots', []) %}
{% set spec = root ~ '(/.*)?' %}
samba_selinux_policy_{{ root }}:
  selinux.fcontext_policy_present:
    - name: {{ spec }}
    - sel_type: samba_share_t
    - filetype: a
{% endfor %}

smb:
  service.running:
    - enable: True
    - require:
      - pkg: samba

nmb:
  service.running:
    - enable: True
    - require:
      - pkg: samba

broadcast_smb_avahi:
  file.managed:
    - name: /etc/avahi/services/samba.service
    - source: salt://{{ slspath }}/files/avahi-service.xml
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: avahi

  service.running:
    - name: avahi-daemon
    - enable: True
    - reload: True
    - require:
      - file: /etc/avahi/services/samba.service
