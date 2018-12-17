{% for group in pillar['groups'] %}
group_{{ group['name'] }}:
  group.present:
    - name: {{ group['name'] }}
    - gid: {{ group['gid'] }}
{% endfor %}

{% for user in pillar['users'] %}
user_{{ user['name'] }}:
  group.present:
    - name: {{ user['name'] }}
    - gid: {{ user['gid'] }}

  user.present:
    - name: {{ user['name'] }}
    - fullname: {{ user['fullname'] }}
    - password: {{ user['password'] }}
    - hash_password: True
    - createhome: {{ user['createhome'] or True }}
    - shell: {{ user['shell'] }}
    - uid: {{ user['uid'] }}
    - gid: {{ user['gid'] }}
    {% if 'groups' in user %}
    - groups:
      {% for group in user['groups'] %}
      - {{ group }}
      {% endfor %}
    {% endif %}
    - require:
        - group: user_{{ user['name'] }}
{% endfor %}
