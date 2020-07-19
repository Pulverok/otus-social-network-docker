#!/bin/bash
# must be chmod +x

# repos for deploy
REPOS=(
    otus-social-network-docker
    otus-social-network-api
    otus-social-network-db
    otus-social-network-docker
    otus-social-network-frontend
)

for repo in ${REPOS[@]}; do
    git -C ../$repo pull || git clone git@github.com:Pulverok/$repo.git ../$repo
done
