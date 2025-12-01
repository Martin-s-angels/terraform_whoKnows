
## to use this repo 

clone repo
open in devcontainer.

first you must login to azure via the azure cli with this command: 

```bash
 az login
```

Verify the login:
```bash
 az account show
```

for it to run automatically you need to create a terraform.tfvars file in the folder of the resource you wish to use with the following lines: 
```bash
subscription_id = "the subscription_id shown when you said az account show "
vm_name = "name of the resource"
ssh_key_name = "name of your ssh key pair"
```


first you must cd into the folder that contain the resource you wish to use 

then use the following commands 

```bash
  terraform init
  terraform plan
```

then when you wish to create the resource then simply run: 
```bash
  terraform apply 
```

to remove the resource again then simply type: 
```bash
  terraform destroy
```


