```bash
sudo apt install python-pip
sudo -H pip install --upgrade pip
sudo -H pip install setuptools
sudo -H pip install ansible
sudo -H pip install cryptography
sudo -H pip install netaddr
ansible-playbook -i inventory/terraform.py all.yml
```
