include:
  - nfs.server

nfs_firewalld_service:
  firewalld.present:
    - name: public
    - prune_services: False
    - services:
      - nfs
