# Demo 1 Eschool
# General scheme of the project
![Demo 1](http://i.piccy.info/i9/44f7701aeca4b0aa7c4eaef37a0549a5/1597913853/68933/1392829/demo1_2020.jpg)
### This repository contains all the necessary information to create the infrastructure, configure servers, frontend and backend builds, as well as CI/CD project.
__Must be installed:__
- __[terraform](https://www.terraform.io/downloads.html)__ version => 0.12.0
### To get started, you'll need to change the variables:
* key to Google account
* access key and secret key for amazon cloud
* generate your ssh key
* generate tokens from the git lab runners
### Link to frontend and backend git repositories:
* __[frontend](https://github.com/OlehKuryshko/final_project)__
* __[backend](https://github.com/OlehKuryshko/eSchool)__
### After you have changed all the variables, run the following command
```bash
terraform init
```
### After "Terraform has been successfully initialized!" please run second command
```bash
terraform apply
```
##### P.S.
You can make yourself coffee, in 10-15 minutes, everything will be ready
___
### How does it work?
>Initially, terraform creates the entire infrastructure, namely instances, creates and configures the network, firewalls, load balancers, runs a script to install the ansible on the ansible instance, after successful installation of the ansible, runs the ansible playbook to further configure servers, as well as cloning frontend and backend repositorys, build them, and launch. After that, this project is fully operational. After the implementation of any committee in the repository of the frontend or backend, the Gitlab CI CD is launched, and our project is updated automatically.