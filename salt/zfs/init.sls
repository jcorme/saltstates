add_zfs_repo:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
    - source: salt://{{ slspath }}/files/RPM-GPG-KEY-zfsonlinux
    - user: root
    - group: root
    - mode: 0644

  pkgrepo.managed:
    - name: zfs-testing-kmod
    - humanname: ZFS on Linux for EL7 - kmod - Testing
    - baseurl: http://download.zfsonlinux.org/epel-testing/7.6/kmod/$basearch/
    - enabled: True
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
    - metadata_expire: 7d

install_zfs_deps:
  pkg.installed:
    - pkgs:
      - sysstat

install_zfs_pkg:
  pkg.installed:
    - name: zfs
    - fromrepo: zfs-testing-kmod
    - refresh: True
    - version: 0.8.1-1.el7
    - allow_updates: False
    - require:
        - install_zfs_deps

{% for pool in salt['pillar.get']('host:zfs:pools', []) %}
cron_scrub_zfs_pool_{{ pool }}:
  cron.present:
    - name: zpool scrub {{ pool }} >/dev/null 2>&1
    - user: root
    - minute: 0
    - hour: 9
    - dayweek: 1
{% endfor %}
