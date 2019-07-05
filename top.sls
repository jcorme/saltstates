base:
  '*':
    - packages
    - users
    - mlxcfg
  'alpha.jcn':
    - zfs
    - samba.server
    - nfs-server
  'poudry*':
    - poudriere
