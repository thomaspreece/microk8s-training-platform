# SecurityShepherd

## Step 1: Build Docker Image
Run `./buildDockerImage.sh`

## Step 2: Push Docker Image
Run `Docker push rdctf/security-shepherd`

## Step 3: Deploy Yaml
```
kubectl apply -f security-shepherd-app-deployment.yaml
kubectl apply -f security-shepherd-louketo-proxy-deployment.yaml
kubectl apply -f security-shepherd-mysql-db-deployment.yaml
kubectl apply -f security-shepherd-network-policy.yaml
```

## Step 4: Setup SecurityShepherd Database
You'll need to login to the securityshepherd url
Next you'll need to `cat /usr/local/tomcat//conf/SecurityShepherd.auth` on SecurityShepherd pod to then use in the UI to setup the database. (You can exec into pod from Kubernetes Dashboard)

## Step 5: Login As Admin
Username: admin
Password: password
