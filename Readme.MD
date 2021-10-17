# Lottery System

## This repository contains:

1)  A simple web server in Go that should mock central lottery machine. 
2)  Dockerfile for this web server.
3)  An exemple YAML file that uses this container image. In actual practice helmchart would be used. 
4)  A sample Jenkins file that contains steps for continuous integration and continuous delivery.

A seperate Github actions file is also provided at the end takes care of continuous deployment using helm and helmfile. 

### The sample web server has following endpoints:

&nbsp;&nbsp;&nbsp;  i) Health endpoint. GET https://{hostname}/health

   &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (1) This endpoint returns json {"status":"ok"} if the system is up and
running.

&nbsp;&nbsp;ii) Lottery endpoint. POST https://{hostname}/lottery

&nbsp;&nbsp;&nbsp; (1) Payload should have a lottery number and store ID.

&nbsp;&nbsp;&nbsp; (2) This endpoint returns json {"status":"ok"}

----- 
### Example yaml file (Point3 above)
deployToK8s.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: lottery-system
  name: lottery-system-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: lottery-system
  strategy:
    type: RollingUpdate
    rollingUpdate:
     maxUnavailable: 25%
     maxSurge: 1
  template:
    metadata:
      labels:
        app: lottery-system
    spec:
      securityContext:
        runAsUser: 1000
        runAsGroup: 3000
        fsGroup: 2000
      containers:
      - image: mirage2012/lottery-system:1.0.0
        name: lottery-system-container
        resources:
          requests:
            memory: "10Mi"
            cpu: "10m"
          limits:
            memory: "32Mi"
            cpu: "20m"
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: lottery-system
  name: lottery-system-service
spec:
  ports:
  - name: appport
    port: 8090
    protocol: TCP
    targetPort: 8090
  selector:
    app: lottery-system
  type: ClusterIP

---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: lottery-system
spec:
  ingressClassName: nginx
  rules:
  - host: myawesome.kubernetes.example
    http:
      paths:
      - path: /health
        backend:
          serviceName: lottery-system-service
          servicePort: 8090
      - path: /lottery
        backend:
          serviceName: lottery-system-service
          servicePort: 8090
```          
----
### Example Github Actions file 
githubActions.yaml
```
# A simplistic Github Actions workflow to deploy using helmfile.

name: CD

env:
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  AWS_REGION: ${{ secrets.AWS_DEFAULT_REGION }}


# Controls when the workflow will run
on:
  # Triggers the workflow on push  events but only for the main branch
  push:
    branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  deploytoK8s:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v2

      - name: installtion of helmfile
        run: wget https://github.com/roboll/helmfile/releases/download/v0.141.0/helmfile_linux_amd64

      - name: Change the permission helmfile
        run: chmod 755 helmfile_linux_amd64

      - name: Move into /usr/local/bin/helmfile
        run: mv helmfile_linux_amd64 /usr/local/bin/helmfile

      - name: Get Kubeconfig
        run: aws eks  update-kubeconfig --name pq-eks-nEXxP5cf --region ${{ env.AWS_REGION }}

      - name: add helm repos
        run: helmfile repos

      - name: install helmfile
        run: helmfile sync
```

