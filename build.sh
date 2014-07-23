#!/bin/bash -u

SOURCE_DIR=.
ASSETS_DIR=assets
BUILD_DIR=build
MANUSCRIPT_NAME=manuscript
OUTPUT_NAME=Report

cleanup() {
  rm -rf \
    "${MANUSCRIPT_NAME}.out" \
    "${MANUSCRIPT_NAME}.log" \
    "${MANUSCRIPT_NAME}.dvi" \
    "${MANUSCRIPT_NAME}.aux" \
    "${BUILD_DIR}"
}

precompile() {
  mkdir -p "${BUILD_DIR}"

  for procfile in $( ls ${SOURCE_DIR} | grep .md$ ); do
    pandoc "${SOURCE_DIR:-.}/${procfile}" -o "${BUILD_DIR}/${procfile}.tex"
    ruby -e '
      print gets(nil)
        .gsub(/includegraphics/,"includegraphics[width=1.0\\columnwidth]")
        .gsub(/begin{verbatim}(:?\n@)?/,"begin{lstlisting}")
        .gsub(/end{verbatim}/,"end{lstlisting}")
    ' -i "${BUILD_DIR}/${procfile}.tex"
  done

  for imagefile in $( ls ${ASSETS_DIR} | grep .jpg$ ); do
    extractbb "${ASSETS_DIR}/${imagefile}"
  done
}

build() {
  platex "${MANUSCRIPT_NAME}.tex"
  dvipdfmx -o "${OUTPUT_NAME}.pdf" "${MANUSCRIPT_NAME}.dvi"
}

case "$1" in
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
