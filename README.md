### lynx

## Requirements

1. AWS credentials setup
2. github credentials to the repos in tigera-cs
3. The ansible vault password

## Howto

1. Clone the repo
2. Create a file in the repo called .vault_password containing the password for the encrypted secrets in this repo
3. pip install -r requirements.txt --user to get required python packages
4. ansible-galaxy install -r requirements.yaml to get the required ansible collections.
5. ansible-playbook create.yaml to create Lynx with the default settings
6. ansible-playbook destroy.yaml to delete the same
