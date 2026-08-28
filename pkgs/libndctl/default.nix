{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  asciidoctor,
  iniparser,
  json_c,
  keyutils,
  kmod,
  udev,
  util-linux,
  libtracefs,
  libtraceevent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libndctl";
  version = "81";

  src = fetchFromGitHub {
    owner = "pmem";
    repo = "ndctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-geOfaI5XehucLanNS8KTIyOAXOS5YSjs61hfrWbmqSs=";
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    asciidoctor
  ];

  buildInputs = [
    iniparser
    json_c
    keyutils
    kmod
    udev
    util-linux
    libtracefs
    libtraceevent
  ];

  mesonFlags = [
    (lib.mesonOption "rootprefix" "${placeholder "out"}")
    (lib.mesonOption "sysconfdir" "${placeholder "out"}/etc/ndctl.conf.d")
    (lib.mesonEnable "asciidoctor" true)
    (lib.mesonEnable "systemd" false)
    (lib.mesonOption "iniparserdir" "${iniparser}")
  ];

  postPatch = ''
    patchShebangs test

    substituteInPlace git-version --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace git-version-gen --replace-fail /bin/sh ${stdenv.shell}

    echo "m4_define([GIT_VERSION], [${finalAttrs.version}])" > version.m4;
  '';

  meta = {
    description = "Tools for managing the Linux Non-Volatile Memory Device sub-system";
    homepage = "https://github.com/pmem/ndctl";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
})
