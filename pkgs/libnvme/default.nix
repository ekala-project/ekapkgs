{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  json_c,
  keyutils,
  meson,
  ninja,
  openssl,
  perl,
  pkg-config,
  python3,
  swig,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnvme";
  version = "1.16.2";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M+SkxzNrRSBu5EmdK82Qh8MPDqGO7fKbdrU9irScARY=";
  };

  postPatch = ''
    patchShebangs scripts
    substituteInPlace test/sysfs/tree-diff.sh test/config/config-diff.sh \
      --replace-fail /bin/bash ${bash}/bin/bash
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    perl
    pkg-config
    python3
    swig
  ];

  buildInputs = [
    keyutils
    json_c
    openssl
    systemd
    python3
  ];

  mesonFlags = [
    "-Ddocs=man"
    (lib.mesonBool "tests" false)
    (lib.mesonBool "docs-build" true)
  ];

  preConfigure = ''
    export KBUILD_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH)"
  '';

  meta = {
    description = "C Library for NVM Express on Linux";
    homepage = "https://github.com/linux-nvme/libnvme";
    maintainers = [ ];
    license = with lib.licenses; [ lgpl21Plus ];
    platforms = lib.platforms.linux;
  };
})
