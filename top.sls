base:
  '*':
    - packages
    - users
    - mlxcfg
    - wireguard
  'alpha.jcn':
    - zfs
    - samba.server
    - nfs-server
  'poudry*':
    - poudriere
