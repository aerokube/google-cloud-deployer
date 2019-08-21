# Google Cloud Deployer

This repository contains source code used to deploy Moon in Google Cloud Marketplace.

To build an image:

1. Login to `gcr.io` registry:

```
$ gcloud auth configure-docker
```

2. Run the script:
```
$ ./build.sh
```
