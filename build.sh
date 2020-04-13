#!/bin/bash

set -e

die(){
    echo $1
    return 1
}

require_command(){
    cmd_name=$1
    if [ -z $(command -v $1) ]; then
        die "$1 command required for this script to run"
    fi
}

request_answer(){
    prompt=$1
    default_value=$2
    if [ -n "$default_value" ]; then
        prompt="$prompt [$default_value]"
    fi
    read -p "$prompt " value
    if [ -z "$value" -a -n "$default_value" ]; then
        value="$default_value"
    fi
    echo "$value"
}

require_command "cut"
require_command "docker"
require_command "echo"

echo "Marketplace tools tags can be listed with 'gcloud container images list-tags gcr.io/cloud-marketplace-tools/k8s/deployer_helm' command."
marketplace_tools_tag=$(request_answer "Specify marketplace tools tag:" "0.10.1")
moon_version=$(request_answer "Specify Moon version:" "1.4.2")
selenoid_ui_version=$(request_answer "Specify Selenoid UI version:" "1.10.0")

moon_major_version="$(cut -d'.' -f1 <<<${moon_version})"
moon_minor_version="$(cut -d'.' -f2 <<<${moon_version})"
moon_patch_version="$(cut -d'.' -f3 <<<${moon_version})"

deployer_version=$(request_answer "Specify deployer version tag:" "$moon_major_version.$moon_minor_version")
moon_registry="gcr.io/aerokube-software-public/moon"
deployer_image_ref="$moon_registry/deployer:$deployer_version"

docker build --build-arg REGISTRY="$moon_registry" --build-arg TAG="$moon_version" --build-arg SELENOID_UI_TAG="$selenoid_ui_version" --build-arg MARKETPLACE_TOOLS_TAG="$marketplace_tools_tag" -t "$deployer_image_ref" -f deployer/Dockerfile .

push=$(request_answer "Successfully built $deployer_image_ref. Push?" "y")

if [ "$push" == "y" ]; then
    docker push "$deployer_image_ref"
fi
