#!/bin/bash
set -e -x -u
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo $SCRIPT_DIR

export IMAGE_NAME="blog"

pushd ${SCRIPT_DIR}

docker build --rm -t ${IMAGE_NAME} .

popd

BLOG_ROOT=${SCRIPT_DIR}/..

pushd ${BLOG_ROOT}

docker run -it --rm \
  --name "blog" \
  -w ${BLOG_ROOT} \
  -v "${BLOG_ROOT}:${BLOG_ROOT}" \
  -p 4000:4000 \
  ${IMAGE_NAME} \
  yarn install \
  && sed -ie 's/per_page:.*,/per_page:1,/g' node_modules/hexo-generator-index/index.js \
  && hexo server

popd
