add_zfs_repo:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
    - source: salt://{{ slspath }}/files/RPM-GPG-KEY-zfsonlinux
    - user: root
    - group: root
    - file_mode: 0644

  pkgrepo.managed:
    - name: zfs-testing-kmod
    - humanname: ZFS on Linux for EL7 - kmod - Testing
    - baseurl: http://download.zfsonlinux.org/epel-testing/7.6/kmod/$basearch/
    - enabled: True
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
    - metadata_expire: 7d
