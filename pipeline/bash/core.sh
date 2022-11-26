#!/usr/bin/env bash

# Environment Flags
set -o errexit  # Exit when a command fails
set -o pipefail # Catch mysqldump fails
set -o nounset  # Exit when using undeclared variables

# Import
if [[ "${BOILERPLATE_CORE_IMPORTED:-}" == "true" ]]; then
  return
fi
BOILERPLATE_CORE_IMPORTED="true"

# Path
if [[ "${PATH}" != *"/usr/sbin"* && -d "/usr/sbin" ]]; then
  export PATH="/usr/sbin:${PATH}"
fi

if [[ "${PATH}" != *"/usr/local/bin"* && -d "/usr/local/bin" ]]; then
  export PATH="/usr/local/bin:${PATH}"
fi

if [[ "${PATH}" != *"/opt/homebrew/bin"* && -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
fi

if [[ "${PATH}" != *"${PWD}/.bin"* && -d "${PWD}/.bin" ]]; then
  export PATH="${PWD}/.bin:${PATH}"
fi

# Colors
if [[ "${BOILERPLATE_NO_COLOR:-}" != "true" ]]; then
  export FORCE_COLOR=1
  export TERM="xterm-256color"
fi

if [[ "${BOILERPLATE_NO_COLOR:-}" == "true" ]]; then

  export CLEAR_COLOR=""
  export BOLD_COLOR=""
  export DIM_COLOR=""
  export UNDERLINED_COLOR=""
  export BLINK_COLOR=""
  export INVERTED_COLOR=""
  export HIDDEN_COLOR=""

  export DEFAULT_COLOR=""
  export BLACK_COLOR=""
  export RED_COLOR=""
  export GREEN_COLOR=""
  export YELLOW_COLOR=""
  export BLUE_COLOR=""
  export MAGENTA_COLOR=""
  export CYAN_COLOR=""
  export LIGHT_GRAY_COLOR=""
  export DARK_GRAY_COLOR=""
  export LIGHT_RED_COLOR=""
  export LIGHT_GREEN_COLOR=""
  export LIGHT_YELLO_COLOR=""
  export LIGHT_BLUE_COLOR=""
  export LIGHT_MAGENTA_COLOR=""
  export LIGHT_CYAN_COLOR=""
  export WHITE_COLOR=""

  export BG_DEFAULT_COLOR=""
  export BG_BLACK_COLOR=""
  export BG_RED_COLOR=""
  export BG_GREEN_COLOR=""
  export BG_YELLOW_COLOR=""
  export BG_BLUE_COLOR=""
  export BG_MAGENTA_COLOR=""
  export BG_CYAN_COLOR=""
  export BG_LIGHT_GRAY_COLOR=""
  export BG_DARK_GRAY_COLOR=""
  export BG_LIGHT_RED_COLOR=""
  export BG_LIGHT_GREEN_COLOR=""
  export BG_LIGHT_YELLOW_COLOR=""
  export BG_LIGHT_BLUE_COLOR=""
  export BG_LIGHT_MAGENTA_COLOR=""
  export BG_LIGHT_CYAN_COLOR=""
  export BG_WHITE_COLOR=""

else

  export CLEAR_COLOR="\033[0m"
  export BOLD_COLOR="\033[1m"
  export DIM_COLOR="\033[2m"
  export UNDERLINED_COLOR="\033[4m"
  export BLINK_COLOR="\033[5m"
  export INVERTED_COLOR="\033[7m"
  export HIDDEN_COLOR="\033[8m"

  export DEFAULT_COLOR="\033[39m"
  export BLACK_COLOR="\033[30m"
  export RED_COLOR="\033[31m"
  export GREEN_COLOR="\033[32m"
  export YELLOW_COLOR="\033[33m"
  export BLUE_COLOR="\033[34m"
  export MAGENTA_COLOR="\033[35m"
  export CYAN_COLOR="\033[36m"
  export LIGHT_GRAY_COLOR="\033[37m"
  export DARK_GRAY_COLOR="\033[90m"
  export LIGHT_RED_COLOR="\033[91m"
  export LIGHT_GREEN_COLOR="\033[92m"
  export LIGHT_YELLO_COLOR="\033[93m"
  export LIGHT_BLUE_COLOR="\033[94m"
  export LIGHT_MAGENTA_COLOR="\033[95m"
  export LIGHT_CYAN_COLOR="\033[96m"
  export WHITE_COLOR="\033[97m"

  export BG_DEFAULT_COLOR="\033[49m"
  export BG_BLACK_COLOR="\033[40m"
  export BG_RED_COLOR="\033[41m"
  export BG_GREEN_COLOR="\033[42m"
  export BG_YELLOW_COLOR="\033[43m"
  export BG_BLUE_COLOR="\033[44m"
  export BG_MAGENTA_COLOR="\033[45m"
  export BG_CYAN_COLOR="\033[46m"
  export BG_LIGHT_GRAY_COLOR="\033[47m"
  export BG_DARK_GRAY_COLOR="\033[100m"
  export BG_LIGHT_RED_COLOR="\033[101m"
  export BG_LIGHT_GREEN_COLOR="\033[102m"
  export BG_LIGHT_YELLOW_COLOR="\033[103m"
  export BG_LIGHT_BLUE_COLOR="\033[104m"
  export BG_LIGHT_MAGENTA_COLOR="\033[105m"
  export BG_LIGHT_CYAN_COLOR="\033[106m"
  export BG_WHITE_COLOR="\033[107m"

fi

export OK_COLOR="${GREEN_COLOR}"
export ERROR_COLOR="${RED_COLOR}"
export WARN_COLOR="${LIGHT_RED_COLOR}"

# Output
function logFormat() {

  local LOCAL_BOILERPLATE_LOG_TIME="${BOILERPLATE_LOG_TIME:-}"
  local LOCAL_BOILERPLATE_NO_EMPTY_LINE="${BOILERPLATE_NO_EMPTY_LINE:-}"

  SCRIPT_PATH=""
  for BASH_SOURCE_ITEM in "${BASH_SOURCE[@]}"; do
    if [[ "${BASH_SOURCE_ITEM}" != "${BASH_SOURCE[0]}" ]]; then
      SCRIPT_PATH="${SCRIPT_PATH}${CLEAR_COLOR}[${BLUE_COLOR}${BASH_SOURCE_ITEM##*/}${CLEAR_COLOR}]"
    fi
  done

  local LINE
  while IFS='' read -r LINE || [[ -n "${LINE}" ]]; do

    if [[ "${LOCAL_BOILERPLATE_NO_EMPTY_LINE}" == "true" && "${LINE}" == "" ]]; then
      continue
    fi

    if [[ -n "${1:-}" && "${1:-}" == "--error" ]]; then

      if [[ "${LINE}" == [+]*" "* ]]; then
        echo
        echo -e "${BOLD_COLOR}${LINE}${CLEAR_COLOR}"
        echo
        continue
      fi

      echo -e "${WARN_COLOR}STDERR${CLEAR_COLOR} ${LINE}${CLEAR_COLOR}"
      continue

    fi

    local PREFIX=""

    if [[ "${LOCAL_BOILERPLATE_LOG_TIME}" == "true" ]]; then
      local TIME
      TIME="$(
        date +"%Y-%m-%d %H:%M:%S %Z"
      )"
      PREFIX="${PREFIX}${DARK_GRAY_COLOR}${TIME}"
    fi

    PREFIX="${PREFIX}${SCRIPT_PATH}"

    echo -e "${PREFIX}${CLEAR_COLOR} ${LINE}${CLEAR_COLOR}"

  done
}

function registerLogger() {
  echo
  exec 3>&1
  exec > >(logFormat)
  exec 2> >(logFormat --error)
}

LOCAL_BOILERPLATE_LOGGER="${BOILERPLATE_LOGGER:-true}"
if [[ "${LOCAL_BOILERPLATE_LOGGER}" == "true" ]]; then
  registerLogger
fi

# Dependencies
function dependency() {

  local DEPENDENCY_NAME="${1:-}"

  if ! command -v "${DEPENDENCY_NAME}" >/dev/null; then

    echo "Dependency \"${DEPENDENCY_NAME}\" not found."

    case "${DEPENDENCY_NAME}" in
    aws)
      if command -v "brew" >/dev/null; then
        (
          set -x
          brew install "awscli"
        )
        echo
      else
        echo "No installation script support for \"${DEPENDENCY_NAME}\"." >&2
        return 1
      fi
      ;;
    bc)
      if command -v "brew" >/dev/null; then
        (
          set -x
          brew install "bc"
        )
        echo
      else
        echo "No installation script support for \"${DEPENDENCY_NAME}\"." >&2
        return 1
      fi
      ;;
    envkey-source)
      (
        set -x
        (
          curl -s "https://raw.githubusercontent.com/envkey/envkey-source/master/install.sh" |
            bash &&
            command -v "envkey-source"
        ) ||
          (
            curl -s "https://raw.githubusercontent.com/envkey/envkey-source/master/install.sh" |
              sed "s|sudo ||g" |
              bash &&
              command -v "envkey-source"
          )
      )
      ;;
    fnm)
      (
        set -x
        curl -fsSL "https://github.com/Schniz/fnm/raw/master/.ci/install.sh" | bash
      )
      ;;
    git)
      if command -v "brew" >/dev/null; then
        (
          set -x
          brew install "git"
        )
        echo
      else
        echo "No installation script support for \"${DEPENDENCY_NAME}\"." >&2
        return 1
      fi
      ;;
    git-lfs)
      if command -v "brew" >/dev/null; then
        (
          set -x
          brew install "git-lfs"
        )
        echo
      else
        echo "No installation script support for \"${DEPENDENCY_NAME}\"." >&2
        return 1
      fi
      ;;
    jq)
      if command -v "brew" >/dev/null; then
        (
          set -x
          brew install "jq"
        )
        echo
      else
        (
          set -x
          curl \
            --location \
            --output "./.bin/jq" \
            "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
          chmod +x "./.bin/jq"
        )
      fi
      ;;
    node)
      if command -v "brew" >/dev/null; then
        (
          set -x
          brew install "node"
        )
        echo
      else
        dependency "fnm"
        (
          set -x
          fnm install "latest"
          fnm use "latest"
        )
      fi
      ;;
    shellcheck)
      if command -v "brew" >/dev/null; then
        (
          set -x
          brew install "shellcheck"
        )
        echo
      else
        echo "No installation script support for \"${DEPENDENCY_NAME}\"." >&2
        return 1
      fi
      ;;
    *)
      echo "No installation script support for \"${DEPENDENCY_NAME}\"." >&2
      return 1
      ;;
    esac

    if ! command -v "${DEPENDENCY_NAME}" >/dev/null; then
      echo "Dependency \"${DEPENDENCY_NAME}\" not found after installing." >&2
      return 1
    fi

  fi
}

# Basic dependencies
dependency "jq"

# Project
function projectKey() {
  jq --raw-output '.name' "./package.json" |
    sed \
      -e 's|/|-|g' \
      -e 's|@||g'
}

function updateProjectVersion() {

  local CURRENT_BRANCH
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

  if [[ "${CURRENT_BRANCH}" != "release/"* && "${CURRENT_BRANCH}" != "hotfix/"* ]]; then
    return
  fi

  local VERSION="${CURRENT_BRANCH}"
  VERSION="${VERSION#release/}"
  VERSION="${VERSION#hotfix/}"

  echo
  echo "Detected project version:"
  echo "VERSION='${VERSION}'"
  echo

  if [[ "${VERSION}" != *"."*"."* ]]; then
    VERSION="${VERSION}.0"
  fi

  TEMP_FILE="$(mktemp)"

  jq ".version=\"${VERSION}\"" "./package.json" >"${TEMP_FILE}" &&
    mv "${TEMP_FILE}" "./package.json"

  if [[ -f "./package-lock.json" ]]; then
    jq ".version=\"${VERSION}\"|.packages.\"\".version=\"${VERSION}\"" "./package-lock.json" >"${TEMP_FILE}" &&
      mv "${TEMP_FILE}" "./package-lock.json"
  fi
}

# Git Hooks
if command -v "git" >/dev/null && [[ -d "./.git" ]]; then

  git --no-optional-locks config "core.hooksPath" ".githooks" ||
    true # Ignore errors locking .git/config

  git --no-optional-locks fetch --tags --prune "origin" 2>/dev/null &

fi

# DotEnv
DOT_ENV_LOADED="false"

function loadDotEnv() {

  if [[ "${DOT_ENV_LOADED}" != "true" && -f "./.env" ]]; then

    echo
    echo "Loading .env..."

    while IFS='' read -r LINE || [[ -n "${LINE}" ]]; do

      if [[ "${LINE}" == *"="* && "${LINE}" != "#"* ]]; then

        local KEY
        KEY="$(sed -E "s|=.*$||" <<<"${LINE}")"
        # echo "KEY = '${KEY}'"

        if [[ -z "$(eval "echo \${${KEY}:-}")" ]]; then
          export "${LINE?}"
          echo "Loaded '${KEY}' from .env"
        fi

      fi

    done <"./.env"

    DOT_ENV_LOADED="true"

    echo "Done loading .env."

  fi

}

# EnvKey
function loadEnvKey() {

  local OPTIONAL="false"
  if [[ "$*" == *"--optional"* || "$*" == *"-o"* ]]; then
    OPTIONAL="true"
  fi

  loadDotEnv

  echo
  echo "Loading EnvKey..."

  if [[ "${OPTIONAL}" != "true" && -z "${ENVKEY:-}" ]]; then
    echo "Missing ENVKEY." >&2
    return 1
  fi

  if [[ "${OPTIONAL}" == "true" && -z "${ENVKEY:-}" ]]; then
    echo "ENVKEY not found. Skipped loading."
    return
  fi

  dependency "envkey-source"

  local TEMP_FOLDER
  TEMP_FOLDER="$(mktemp -d)"

  local ENVKEY_BEFORE="${TEMP_FOLDER}/envkey.before"
  printenv | sort >"${ENVKEY_BEFORE}"

  echo "Runing envkey-source..."
  # set -x
  eval "$(envkey-source "${ENVKEY}")"

  local ENVKEY_AFTER="${TEMP_FOLDER}/envkey.after"
  printenv | sort >"${ENVKEY_AFTER}"

  echo "Found:"
  diff "${ENVKEY_BEFORE}" "${ENVKEY_AFTER}" |
    grep -E "[A-Z_]+=" |
    sed 's|=.*$||' ||
    true

  rm -rf "${TEMP_FOLDER}"

  echo "Done loading EnvKey."
}

function loadDeployEnvKey() {

  local OPTIONAL="false"
  if [[ "$*" == *"--optional"* || "$*" == *"-o"* ]]; then
    OPTIONAL="true"
  fi

  loadDotEnv

  echo
  echo "Loading Deploy EnvKey..."

  if [[ "${OPTIONAL}" != "true" && -z "${DEPLOY_ENVKEY:-}" ]]; then
    echo "Missing DEPLOY_ENVKEY." >&2
    return 1
  fi

  if [[ "${OPTIONAL}" == "true" && -z "${DEPLOY_ENVKEY:-}" ]]; then
    echo "DEPLOY_ENVKEY not found. Skipped loading."
    return
  fi

  dependency "envkey-source"

  local TEMP_FOLDER
  TEMP_FOLDER="$(mktemp -d)"

  local ENVKEY_BEFORE="${TEMP_FOLDER}/envkey.before"
  printenv | sort >"${ENVKEY_BEFORE}"

  echo "Runing envkey-source..."
  # set -x
  eval "$(envkey-source "${DEPLOY_ENVKEY}")"

  local ENVKEY_AFTER="${TEMP_FOLDER}/envkey.after"
  printenv | sort >"${ENVKEY_AFTER}"

  echo "Found:"
  diff "${ENVKEY_BEFORE}" "${ENVKEY_AFTER}" |
    grep -E "[A-Z_]+=" |
    sed 's|=.*$||' ||
    true

  rm -rf "${TEMP_FOLDER}"

  echo "Done loading Deploy EnvKey."

  if [[ -n "${SERVICE_ENVKEY:-}" ]]; then
    if [[ -z "${ENVKEY:-}" ]]; then
      export ENVKEY="${SERVICE_ENVKEY}"
      echo "SERVICE_ENVKEY exported as ENVKEY."
    else
      echo "SERVICE_ENVKEY ignored as ENVKEY exists."
    fi
  fi
}

# AWS
function checkAWSCredentials() {

  if [[ -z "${AWS_ACCESS_KEY_ID:-}" ]]; then
    echo "Missing AWS_ACCESS_KEY_ID." >&2
    return 1
  fi

  if [[ -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
    echo "Missing AWS_SECRET_ACCESS_KEY." >&2
    return 1
  fi

  export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-"us-east-1"}"

}
