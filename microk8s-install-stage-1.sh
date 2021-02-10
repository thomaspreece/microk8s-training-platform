export LOCAL_USER=$USER

sudo apt-get install pwgen
sudo snap install microk8s --classic --channel=1.19
sudo usermod -a -G microk8s $LOCAL_USER
sudo chown -f -R $LOCAL_USER ~/.kube
sudo microk8s status --wait-ready
# Only ROOT has access to microk8s at this point, need to logout/login again OR
# RUN sudo su - $LOCAL_USER
echo "alias kubectl='microk8s kubectl'" >> /home/$LOCAL_USER/.bash_aliases
echo "alias proxy='microk8s kubectl port-forward --address 0.0.0.0 -n kube-system service/kubernetes-dashboard 9000:443'" >> /home/$LOCAL_USER/.bash_aliases
echo "source <(kubectl completion bash)" >> /home/$LOCAL_USER/.bashrc
