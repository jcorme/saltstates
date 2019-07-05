{% for group in salt['pillar.get']('groups', []) %}
group_{{ group['name'] }}:
  group.present:
    - name: {{ group['name'] }}
    - gid: {{ group['gid'] }}
{% endfor %}

{% for user_name, user in salt['pillar.get']('users', {}).items() %}
user_{{ user_name }}:
  group.present:
    - name: {{ user_name }}
    - gid: {{ user.gid }}

  user.present:
    - name: {{ user_name }}
    - fullname: {{ user.fullname }}
    {% if user.get('empty_password', False) %}
    - empty_password: True
    {% else %}
    - password: {{ user.password }}
    {% endif %}
    - createhome: {{ user.get('createhome', True) }}
    - shell: {{ user.shell }}
    - uid: {{ user.uid }}
    - gid: {{ user.gid }}
    {% if 'groups' in user %}
    - groups:
      {% for group in user.groups %}
      - {{ group }}
      {% endfor %}
    {% endif %}
    - require:
        - group: user_{{ user_name }}
{% endfor %}
