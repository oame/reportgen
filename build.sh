#!/bin/bash -u

SOURCE_DIR=.
ASSETS_DIR=assets
MANUSCRIPT_NAME=manuscript
OUTPUT_NAME=Report

cleanup() {
  rm -rf \
    "${MANUSCRIPT_NAME}.out" \
    "${MANUSCRIPT_NAME}.log" \
    "${MANUSCRIPT_NAME}.dvi" \
    "${MANUSCRIPT_NAME}.aux"
}

precompile() {
  for imagefile in $( ls ${ASSETS_DIR} | grep .jpg$ ); do
    extractbb "${ASSETS_DIR}/${imagefile}"
  done
}

build() {
  platex "${MANUSCRIPT_NAME}.tex"
  dvipdfmx -o "${OUTPUT_NAME}.pdf" "${MANUSCRIPT_NAME}.dvi"
}

case "${1:-''}" in
  cleanup)
    cleanup
    ;;
  precompile)
    precompile
    ;;
  build)
    build
    ;;
  *)
    precompile
    build
    cleanup
    ;;
esac

exit 0
