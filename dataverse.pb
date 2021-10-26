---
# dataverse.pb

- name: Install Dataverse
  hosts: dataverse
  any_errors_fatal: '{{ any_errors_fatal }}'
  become: true
  roles:
    - role: dataverse
