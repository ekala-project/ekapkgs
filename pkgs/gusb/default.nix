{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  python3,
  glib,
  libusb1,
  json-glib,
  hwdata,
}:

let
  pythonEnv = python3.pythonOnBuildForHost.withPackages (
    ps: with ps; [
      setuptools
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "gusb";
  version = "0.4.9";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libgusb";
    tag = version;
    hash = "sha256-piIPNLc3deToyQaajXFvM+CKh9ni8mb0P3kb+2RoJOs=";
  };

  patches = [
    (replaceVars ./fix-python-path.patch {
      python = "${pythonEnv}/bin/python3";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    glib
    libusb1
    json-glib
  ];

  mesonFlags = [
    (lib.mesonBool "docs" false)
    (lib.mesonBool "introspection" false)
    (lib.mesonBool "tests" false)
    (lib.mesonBool "vapi" false)
    (lib.mesonOption "usb_ids" "${hwdata}/share/hwdata/usb.ids")
  ];

  doCheck = false;

  meta = {
    description = "GLib libusb wrapper";
    mainProgram = "gusbcmd";
    homepage = "https://github.com/hughsie/libgusb";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
}
