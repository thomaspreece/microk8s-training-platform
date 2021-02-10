# microk8s-training-platform

This repository has scripts to help install Kubernetes using MicroK8s and then deploy [rd-ctf-2020](https://github.com/thomaspreece/rd-ctf-2020), Security Shepherd and Secure Coding Dojo on top of it.

## Secrets
There are secrets scattered across the YAML and scripts in this repo that you will need to change. This includes:

- Creating `ctfd-oauth2-client-secret.txt`, `secure-coding-dojo-oauth2-client-secret.txt` and `security-shepherd-oauth2-client-secret.txt` in the `KeycloakClientSecrets` folder
- Changing `.env`, `buildDockerImage.sh` and `security-shepherd-mysql-db-db-deployment.yaml` to use non default passwords in the `SecurityShephard` folder.
- Changing any instances of `[FILL_ME_IN]`

## Domains & KeyCloak
The scripts assume you are using KeyCloak so you'll need to replace any [MY_DOMAIN] and [KEYCLOAK URL] strings you find.

## Install
First clone rd-ctf-2020 into this folder:
```
git clone https://github.com/thomaspreece/rd-ctf-2020.git rd-ctfd
```
Now you'll want to run stage 1:
```
./microk8s-install-stage-1.sh
```

Now reboot the machine, followed by stage 2:
```
./microk8s-install-stage-2.sh
```

If you wish to have multiple nodes then run stage 1 on multiple different machines and follow https://microk8s.io/docs/clustering to connect them together to form a cluster.

Do note that an Load Balancer was used to only forward the web and websecure ports of traefik to the internet. Not doing this may result in the admin port being exposed (which can access the traefik dashboard among other things).
