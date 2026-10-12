#!/usr/bin/env bash
set -euo pipefail

flutter_command=(flutter)

if ! command -v flutter >/dev/null 2>&1; then
  sdk_directory="$(mktemp -d "${TMPDIR:-/tmp}/amicooked-flutter.XXXXXX")"
  trap 'rm -rf "$sdk_directory"' EXIT
  curl --fail --location --silent --show-error --retry 3 \
    https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json \
    --output "$sdk_directory/releases.json"

  sdk_release="$(node - "$sdk_directory/releases.json" <<'NODE'
const fs = require('node:fs');
const manifest = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const release = manifest.releases.find(entry =>
  entry.hash === manifest.current_release.stable &&
  entry.channel === 'stable' &&
  (entry.dart_sdk_arch ?? 'x64') === process.arch
);

if (!release || !release.archive || !/^[a-f0-9]{64}$/.test(release.sha256)) {
  throw new Error('No verified stable Flutter archive found for this architecture');
}

console.log(`${manifest.base_url}/${release.archive} ${release.sha256}`);
NODE
  )"
  read -r sdk_url sdk_checksum <<< "$sdk_release"
  curl --fail --location --silent --show-error --retry 3 \
    "$sdk_url" --output "$sdk_directory/flutter.tar.xz"
  printf '%s  %s\n' "$sdk_checksum" "$sdk_directory/flutter.tar.xz" | sha256sum --check -
  tar -xJf "$sdk_directory/flutter.tar.xz" -C "$sdk_directory"
  export FLUTTER_ROOT="$sdk_directory/flutter"
  export PATH="$FLUTTER_ROOT/bin:$PATH"

  if [[ ! -x "$FLUTTER_ROOT/bin/cache/dart-sdk/bin/dart" || \
        ! -f "$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot" || \
        ! -f "$FLUTTER_ROOT/bin/cache/flutter.version.json" ]]; then
    printf 'The Flutter release archive is missing its prebuilt tool or version metadata.\n' >&2
    exit 1
  fi

  node - "$sdk_directory/releases.json" "$FLUTTER_ROOT/bin/cache/flutter.version.json" <<'NODE'
const fs = require('node:fs');
const manifest = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const version = JSON.parse(fs.readFileSync(process.argv[3], 'utf8'));
const release = manifest.releases.find(entry =>
  entry.hash === manifest.current_release.stable &&
  entry.channel === 'stable' &&
  (entry.dart_sdk_arch ?? 'x64') === process.arch
);
const requiredFields = [
  'frameworkVersion', 'channel', 'repositoryUrl', 'frameworkRevision',
  'frameworkCommitDate', 'engineRevision', 'dartSdkVersion',
  'devToolsVersion', 'flutterVersion'
];

if (!release || requiredFields.some(field => typeof version[field] !== 'string') ||
    version.frameworkVersion !== release.version ||
    version.flutterVersion !== release.version ||
    version.frameworkRevision !== release.hash || version.channel !== 'stable' ||
    version.repositoryUrl !== 'https://github.com/flutter/flutter.git') {
  throw new Error('The bundled Flutter version metadata does not match the verified release');
}
NODE

  flutter_command=(
    "$FLUTTER_ROOT/bin/cache/dart-sdk/bin/dart"
    "$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"
    --no-version-check
  )
fi

"${flutter_command[@]}" --version --machine
"${flutter_command[@]}" pub get
"${flutter_command[@]}" build web --release --base-href /
