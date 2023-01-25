#!/bin/bash
#Author- Amila -  Nginx-ingress controller setup for k8s cluster with cert-manager for SSL termination

#install helm latest
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#create ingress-nginx namespace for inggress-nginx controller
kubectl create ns ingress-nginx

#install Nginx-ingress-controller with helm charts 
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

#The following command will wait for the ingress controller pod to be up, running, and ready:
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

#create python-http-app deployment and also create cluster-ip service for the python-app
kubectl apply -f deployment.yaml 

#create kuberenets CRD resource for "cert-manager" kubernetes addon for issue free SSL Certification with Let's Encrypt
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
## Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
#create namespace for cert-manager
kubectl create namespace cert-manager
### Install the cert-manager helm chart with  the release name my-release:
helm install my-release --namespace cert-manager --version v1.11.0 jetstack/cert-manager

#For issuing free certificate, setup the issuer resource by using letsencrypt-staging issuer(server) #https://cert-manager.io/docs/configuration/acme/
kubectl apply -f cert-issuer.yaml

# Now we can request a certificate. Here’s the template for the certificate object.
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-cert  #name of this object
  namespace: prod #same namespace as 
spec:
  dnsNames:
    - demo.localdev.me
  secretName: letsencrypt-nginx
  issuerRef:
    name: letsencrypt-nginx
    kind: Issuer
EOF

#Create THE ingress resource
kubectl apply -f ingress.yaml

# NOW after check your firewall / security group rules you should be able to browse the site with https://demo.localdev.me






