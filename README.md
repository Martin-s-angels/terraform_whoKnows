
## to use this repo 

clone repo\
open in devcontainer.

first you must login to azure via the azure cli with this command: 

```bash
 az login
```

Verify the login:
```bash
 az account show
```

then run the following command in the root folder if you wish to make a new keypair in this devcontainer, or you can copy your keys into ssh in the root repo: 

```bash
mkdir -p ./ssh && ssh-keygen -t ed25519 -f ./ssh/id_ed25519 -N ""
```
this will gernate ssh keys for the vm do remember **THESE WILL BE LOST IF THE DEVCONTAINER IS RESTARTET** so if you want perminant acess then please add your actual machine keys dont worry they should not be pushed to git however please do make sure if you fork or commit to this repo they are not. 

if you add a authorized_keys file into the ssh folder it should be added to the vm created in 01_vm this can be used to add more team members to a vm at once. 

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
  ssh -i ../ssh/my_azure_key [user]@VM_ip
```

if you generated a new key pair in this devContainer remember to use that public when logging into the vm: 
```bash
  terraform apply 
```

to remove the resource again then simply type: 
```bash
  terraform destroy
```


