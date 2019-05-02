#!/bin/sh

# Run unit tests in Docker
set -e

PYTHON_VERSIONS=("2.7" "3.6" "3.7")

for python_version in "${PYTHON_VERSIONS[@]}"
do
    echo "Running tests against python${python_version}"
    docker build -t datadog-lambda-layer-python-test:$python_version \
        -f tests/Dockerfile . \
        --quiet \
        --build-arg python_version=$python_version
    docker run -v `pwd`:/datadog-lambda-layer-python \
        -w /datadog-lambda-layer-python \
        datadog-lambda-layer-python-test:$python_version \
        nose2 -v
    docker run -v `pwd`:/datadog-lambda-layer-python \
        -w /datadog-lambda-layer-python \
        datadog-lambda-layer-python-test:$python_version \
        flake8
done