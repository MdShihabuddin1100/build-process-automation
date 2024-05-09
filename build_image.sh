#!/bin/bash
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)
export IMAGE_TAG=your_tag

DIRECTORY_NAME="frappe_docker"

# Check if the directory exists
if ! [ -d "$DIRECTORY_NAME" ]; then
    echo "Directory $DIRECTORY_NAME does not exist."
    git clone https://github.com/frappe/$DIRECTORY_NAME.git
fi

cp apps.json $DIRECTORY_NAME
cd $DIRECTORY_NAME || exit

docker build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=PYTHON_VERSION=3.11.6 \
  --build-arg=NODE_VERSION=18.18.2 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=$IMAGE_TAG \
  --file=images/custom/Containerfile .

#docker push $IMAGE_TAG