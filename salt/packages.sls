{% if salt['pillar.get']('host:packages', []) | length > 0 %}
install_host_packages:
  pkg.installed:
    - pkgs:
    {% for pkg in salt['pillar.get']('host:packages') %}
      - {{ pkg }}
    {% endfor %}
{% endif %}
