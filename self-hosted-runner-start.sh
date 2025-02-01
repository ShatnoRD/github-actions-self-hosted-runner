#!/bin/bash

ACCESS_TOKEN=$TOKEN
REPOSITORY=$REPO
ORGANIZATION=$ORG
RUNNER_GROUP=$GROUP
RUNNER_NAME=${NAME:-$(cat /etc/hostname)}
LABELS=${LABELS:-"self-hosted"}

check_env() {
    if [ -z "${ACCESS_TOKEN:-}" ]; then
        echo "Error: ACCESS_TOKEN is not set."
        exit 1
    fi

    if [ -z "${RUNNER_NAME:-}" ]; then
        echo "Error: RUNNER_NAME is not set."
        exit 1
    fi
}

register_runner() {
    if [ -n "${REPOSITORY:-}" ]; then
        if [ -n "${ORGANIZATION:-}" ]; then
            echo "Warning: Both REPO and ORG are set. Using REPO."
        fi
        if [ -n "${RUNNER_GROUP:-}" ]; then
            echo "Warning: Both REPO and GROUP are set. Using REPO."
        fi
        # Repository-level
        REG_TOKEN=$(curl -sL \
            -X POST \
            -H "Authorization: token ${ACCESS_TOKEN}" \
            -H "Accept: application/vnd.github+json" \
            https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq -r .token)
        ./config.sh --unattended --url https://github.com/${REPOSITORY} --token ${REG_TOKEN} --name ${NAME} --labels ${LABELS}
    elif [ -n "${ORGANIZATION:-}" ]; then
        if [ -n "${RUNNER_GROUP:-}" ]; then
            # Organization-level with group
            REG_TOKEN=$(curl -sL \
                -X POST \
                -H "Authorization: token ${ACCESS_TOKEN}" \
                -H "Accept: application/vnd.github+json" \
                https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq -r .token)
            ./config.sh --unattended --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN} --name ${NAME} --labels ${LABELS} --runnergroup ${RUNNER_GROUP}
        else
            # Organization-level
            REG_TOKEN=$(curl -sL \
                -X POST \
                -H "Authorization: token ${ACCESS_TOKEN}" \
                -H "Accept: application/vnd.github+json" \
                https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq -r .token)
            ./config.sh --unattended --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN} --name ${NAME} --labels ${LABELS}
        fi
    else
        echo "Error: Either REPO or ORG must be set."
        exit 1
    fi
}

cleanup() {
    echo "Removing runner..."
    if [ -n "${REPOSITORY:-}" ]; then
        # Repository-level
        REG_TOKEN=$(curl -sL \
            -X POST \
            -H "Authorization: token ${ACCESS_TOKEN}" \
            -H "Accept: application/vnd.github+json" \
            https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq -r .token)
    elif [ -n "${ORGANIZATION:-}" ]; then
        # Organization-level
        REG_TOKEN=$(curl -sL \
            -X POST \
            -H "Authorization: token ${ACCESS_TOKEN}" \
            -H "Accept: application/vnd.github+json" \
            https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq -r .token)
    fi
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

check_env

register_runner
./run.sh &
wait $!
