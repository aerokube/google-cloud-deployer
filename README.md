# Google Cloud Deployer

This repository contains source code used to deploy Moon in Google Cloud Marketplace.

## Building

To build an image:

1. Login to `gcr.io` registry:

```
$ gcloud auth configure-docker
```

2. Run the script:
```
$ ./build.sh
```

## Deploying Manually

1. Add `Application` custom resource definition:
```
$ kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
```

2. Manually create `moon` namespace:
```
$ kubectl create namespace moon
```

3. Deploy Moon:
```
$ mpdev install --deployer=gcr.io/aerokube-software-public/moon/deployer:1.3 --parameters='{"name": "moon-test", "namespace": "moon"}'
```
