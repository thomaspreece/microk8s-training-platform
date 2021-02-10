set -e
export LOCAL_USER=$USER

## Basic Addons
sudo microk8s enable dns registry

## HELM
sudo microk8s enable helm3
echo "alias helm='microk8s helm3'" >> /home/$LOCAL_USER/.bash_aliases

## RBAC
sudo microk8s enable rbac

## Setup Dashboard RBAC
sudo microk8s enable dashboard
microk8s kubectl apply -f yaml/clusteradmin.yaml
echo "alias gettoken='microk8s kubectl -n kube-system describe secret clusteradmin | grep token: | cut -d \" \" -f7'" >> /home/$LOCAL_USER/.bash_aliases


## Deploy EchoServer
microk8s kubectl apply -f yaml/echoserver.yaml

## Traefik
# Have to create in default namespace for Traefik to pick it up :/
microk8s kubectl create secret tls traefik-ctf-cert --key="keys/ctf-wildcard-privkey.pem" --cert="keys/ctf-wildcard-fullchain.pem"

microk8s kubectl create namespace traefik
microk8s kubectl label namespace traefik name=traefik
microk8s helm3 repo add traefik https://helm.traefik.io/traefik
microk8s helm3 repo update
microk8s helm3 install traefik traefik/traefik --namespace traefik --values=yaml/traefik_helm.yaml

## Deploy Ingress Rules
microk8s kubectl apply -f yaml/traefik_ingress.yaml

## CTFD
microk8s kubectl create namespace ctfd
microk8s kubectl label namespace ctfd name=ctfd
#microk8s kubectl create secret tls traefik-ctfd-cert --key="keys/ctfd-key.pem" --cert="keys/ctfd-cert.pem" --namespace ctfd

# Note: It is important that there is NOT any newlines in the below file
# otherwise louketo will fail to autenticate with KeyCloak
# See https://www.funkypenguin.co.nz/beware-the-hidden-newlines-in-kubernetes-secrets/
microk8s kubectl create secret generic ctfd-oauth2-client-secret --from-file=KeycloakClientSecrets/ctfd-oauth2-client-secret.txt --namespace ctfd

microk8s kubectl apply -f rd-ctfd/deploy/ctfd-mysql-db-deployment.yaml
microk8s kubectl apply -f rd-ctfd/deploy/ctfd-redis-cache-deployment.yaml
microk8s kubectl apply -f rd-ctfd/deploy/ctfd-deployment.yaml
microk8s kubectl apply -f rd-ctfd/deploy/ctfd-nginx-deployment.yaml
microk8s kubectl apply -f rd-ctfd/deploy/ctfd-louketo-proxy-deployment.yaml

## CTF
microk8s kubectl create namespace ctf
microk8s kubectl label namespace ctf name=ctf

# Note: This network policy by default stops any ctf machine from talking to anything else
# including DNS and the internet
microk8s kubectl apply -f yaml/ctf-network-policy.yaml

## SecurityShephard
microk8s kubectl create namespace security-shepherd
microk8s kubectl label namespace security-shepherd name=security-shepherd

microk8s kubectl create secret generic security-shepherd-oauth2-client-secret --from-file=KeycloakClientSecrets/security-shepherd-oauth2-client-secret.txt --namespace security-shepherd

pwgen 16 1 > ./KeycloakClientSecrets/security-shepherd-cookie-secret.txt
microk8s kubectl create secret generic security-shepherd-cookie-secret --from-file=KeycloakClientSecrets/security-shepherd-cookie-secret.txt --namespace security-shepherd

microk8s kubectl apply -f security-shepherd-app-deployment.yaml
microk8s kubectl apply -f security-shepherd-mysql-db-deployment.yaml
microk8s kubectl apply -f security-shepherd-network-policy.yaml
microk8s kubectl apply -f security-shepherd-oauth2-proxy-deployment.yaml

## SecureCodingDojo
microk8s kubectl create namespace secure-coding-dojo
microk8s kubectl label namespace secure-coding-dojo name=secure-coding-dojo

microk8s kubectl create secret generic secure-coding-dojo-oauth2-client-secret --from-file=KeycloakClientSecrets/secure-coding-dojo-oauth2-client-secret.txt --namespace secure-coding-dojo

pwgen 16 1 > ./KeycloakClientSecrets/secure-coding-dojo-cookie-secret.txt
microk8s kubectl create secret generic secure-coding-dojo-cookie-secret --from-file=KeycloakClientSecrets/secure-coding-dojo-cookie-secret.txt --namespace secure-coding-dojo

microk8s kubectl apply -f secure-coding-dojo-app-deployment.yaml
microk8s kubectl apply -f secure-coding-dojo-app-oauth2-proxy-deployment.yaml
microk8s kubectl apply -f secure-coding-dojo-insecureinc-deployment.yaml
microk8s kubectl apply -f secure-coding-dojo-insecureinc-oauth2-proxy-deployment.yaml
