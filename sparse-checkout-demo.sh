set -e

pull-langs() {
  echo "\$1 repo slug: $1"; repo="$1";
  echo "\$2 branch: $2"; branch="$2";
  echo "\$3 dirs: $3"; dirs="$3";
  echo "\$4 languages: $4"; languages="$4";

  DIRS_FROM_TO=$(echo "${dirs//,/ }" | xargs)
  ATLAS_LANGS=$(echo "${languages//,/ }" | xargs)

  cd /tmp
  rm -rf /tmp/atlas-repo
  git clone --filter=blob:none --no-checkout --depth=1 --branch=$branch "https://github.com/${repo}.git" atlas-repo
  cd atlas-repo

  # Reset git sparse-checkout list of include/exclude files
  # See https://www.git-scm.com/docs/git-sparse-checkout for detailed implementation
  git sparse-checkout set --no-cone

  # Tells sparse checkout to ignore all files, except when otherwise noted
  git sparse-checkout add '!*'

  for DIR_FROM_TO in $DIRS_FROM_TO; do
    DIR_FROM=$(echo "${DIR_FROM_TO}" | cut -f1 -d ':');

    for ATLAS_LANG in $ATLAS_LANGS; do
      # Include directories that matches the language pattern e.g. `/ar/`
      git sparse-checkout add "${DIR_FROM}/**/${ATLAS_LANG}/**"
      # Include files that matches the language pattern e.g. `ar.*`
      git sparse-checkout add "${DIR_FROM}/**/${ATLAS_LANG}.*"
    done
  done

  git checkout $branch
  rm -rf .git
  pwd

  echo "================================================"
  echo "============ Sparse checkout tree =============="
  echo "================================================"
  tree

  mkdir copied_translations
  for DIR_FROM_TO in $DIRS_FROM_TO; do
    DIR_FROM=$(echo "${DIR_FROM_TO}" | cut -f1 -d ':');

    if [[ $DIR_FROM_TO =~ : ]]; then
      DIR_TO=$(echo "${DIR_FROM_TO}" | cut -f2 -d ':');
    else
      DIR_TO=.
    fi

    set -x
    mkdir -p copied_translations/${DIR_TO};
    cp -r ${DIR_FROM}/* copied_translations/${DIR_TO};
    set +x
  done

  echo "================================================"
  echo "============ Result copy tree =================="
  echo "================================================"
  cd copied_translations
  tree


  echo "simulated:"
  echo ""
  echo " $ atlas pull --repo='$repo' --branch='$branch' --directory='$dirs' --languages='$languages'"
  echo ""
}


looks_good() {
  # A separator between commands to inspect the output
  read -p "Looks good? Press enter to continue"
  for i in $(seq 1 20); do
    echo
  done
  clear
}


echo "Start: edX Platform example"
# This is simple
pull-langs openedx/edx-platform master conf/locale:conf/locale fr
echo "End: edX Platform example"
looks_good

echo "Start: Learning MFE example"
# This separates directories in spaces and newlines for readability
pull-langs Zeit-Labs/openedx-translations learning-mfe-translations \
          "translations/frontend-app-learning/src/i18n/messages:frontend-app-learning
           translations/frontend-component-footer/src/i18n/messages:frontend-component-footer
           translations/frontend-component-header/src/i18n/messages:frontend-component-header" \
           fr_CA,ar,es_419
echo "End: Learning MFE example"
looks_good

echo "Start: Credentials"
# This separates directories in commas in a single-line
pull-langs openedx/openedx-translations main translations/credentials/credentials/conf/locale:credentials/conf/locale fr_CA,ar,es_419
echo "End: Credentials"
looks_good

echo "Start: Mini MFE Example"
# This checks out the directories in the current working directory (assumes :.)
pull-langs openedx/frontend-app-learning master src/i18n/messages fr_CA
echo "End: Mini MFE Example"
looks_good


echo "Start: iOS App Example"
# Checkout iOS files in the current working directory
pull-langs openedx/edx-app-ios master Source:. ar.lproj,de.lproj,vi.lproj
echo "End: iOS App Example"
looks_good


echo "Start: Android App Example"
# Checkout Android directories
pull-langs openedx/edx-app-android master OpenEdXMobile/res:droidfiles values-ar,values-fr,values-vi
echo "End: Android App Example"
looks_good
