#!/usr/bin/env bash

# shellcheck source=./lib/bash/core.sh
source "${BASH_SOURCE[0]%/*}/core.sh"

TEMPLATE_FILES=""

function findTemplateFilesIfNeeded() {

  if [[ -z "${TEMPLATE_FILES}" ]]; then
    TEMPLATE_FILES="$(find "${SRCROOT:-.}" -type f -name "*.template.*")"
  fi
}

function removeGeneratedFiles() {

  findTemplateFilesIfNeeded

  echo
  echo "Removing generated files..."

  while IFS='' read -r TEMPLATE_FILE; do

    local OUTPUT_FILE="${TEMPLATE_FILE//.template./.generated.}"

    if [[ -f "${OUTPUT_FILE}" ]]; then
      (
        set -x
        rm -rf "${OUTPUT_FILE}"
      )
    fi

  done <<<"${TEMPLATE_FILES}"
}

function applyEnvVarsToTemplateFiles() {

  findTemplateFilesIfNeeded

  while IFS='' read -r TEMPLATE_FILE; do

    local OUTPUT_FILE="${TEMPLATE_FILE//.template./.generated.}"

    echo
    echo "Generating ${BLUE_COLOR}${OUTPUT_FILE}${CLEAR_COLOR}..."

    local CONTENT
    CONTENT="$(cat "${TEMPLATE_FILE}" 2>/dev/null)"

    local VARS
    VARS="$(
      (grep -E "__[A-Z0-9_]+__" <<<"${CONTENT}" || true) |
        sed -E -e 's|.*__([A-Z0-9_]+)__.*|\1|g'
    )"

    while IFS='' read -r VAR; do

      if [[ -z "${VAR}" ]]; then
        continue
      fi

      local VALUE
      VALUE="$(eval "echo \${${VAR}:-}")"

      # shellcheck disable=SC2001
      CONTENT="$(sed "s|__${VAR}__|${VALUE}|g" <<<"${CONTENT}")"

      if [[ -z "${VALUE}" ]]; then
        echo "${WHITE_COLOR}${VAR}${CLEAR_COLOR} not found."
      else
        echo "${WHITE_COLOR}${VAR}${CLEAR_COLOR} applied."
      fi

    done <<<"${VARS}"

    local OUTPUT_CONTENT=""
    if [[ -f "${OUTPUT_FILE}" ]]; then
      OUTPUT_CONTENT="$(cat "${OUTPUT_FILE}")"
    fi

    if [[ "${CONTENT}" != "${OUTPUT_CONTENT}" ]]; then
      echo "${CONTENT}" >"${OUTPUT_FILE}"
      echo "Changes written."
    else
      echo "Nothing changed."
    fi

  done <<<"${TEMPLATE_FILES}"
}
