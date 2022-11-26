#!/usr/bin/env bash

function checkNodeVersion() {

  dependency "node"

  local EXPECTED_NODE_VERSION="${EXPECTED_NODE_VERSION:-}"
  if [[ -z "${EXPECTED_NODE_VERSION}" ]]; then
    EXPECTED_NODE_VERSION="$(head -n 1 ./.node-version)"
    export EXPECTED_NODE_VERSION="${EXPECTED_NODE_VERSION}"
  fi

  local CURRENT_NODE_VERSION
  CURRENT_NODE_VERSION="$(node -v)"

  if [[ "${CURRENT_NODE_VERSION}" != "v${EXPECTED_NODE_VERSION}" ]]; then

    echo "Expect NodeJS version v${EXPECTED_NODE_VERSION} but have ${CURRENT_NODE_VERSION}." >&2

    dependency "fnm"

    eval "$(fnm env)"

    # Check if expected version is already installed
    if ! fnm ls | grep "${EXPECTED_NODE_VERSION}" >/dev/null; then
      (
        set -x
        fnm install "${EXPECTED_NODE_VERSION}"
      ) || (
        # shellcheck source=/dev/null
        [[ -s "${HOME}/.nvm/nvm.sh" ]] && \. "${HOME}/.nvm/nvm.sh"
        nvm install "${EXPECTED_NODE_VERSION}"
      )
    fi

    if ! (
      set -x
      fnm use "${EXPECTED_NODE_VERSION}"
    ); then
      # shellcheck source=/dev/null
      [[ -s "${HOME}/.nvm/nvm.sh" ]] && \. "${HOME}/.nvm/nvm.sh"
      nvm use "${EXPECTED_NODE_VERSION}"
    fi

    local NODE
    NODE="$(command -v node)"

    CURRENT_NODE_VERSION="$(
      set -x
      "${NODE}" --version
    )"

    echo "${CURRENT_NODE_VERSION}"

  fi

  echo

  if [[ "${CURRENT_NODE_VERSION}" != "v${EXPECTED_NODE_VERSION}" ]]; then
    echo "After installing, expect NodeJS version v${EXPECTED_NODE_VERSION} but have ${CURRENT_NODE_VERSION}." >&2
    return 1
  fi
}

dependency "yarn"

checkNodeVersion
