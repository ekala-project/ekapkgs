{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  libevdev,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  protobuf,
  protobufc ? null,
  systemd,
  buildPackages,
  python3,
}:
let
  munit = fetchFromGitHub {
    owner = "nemequ";
    repo = "munit";
    rev = "fbbdf1467eb0d04a6ee465def2e529e4c87f2118";
    hash = "sha256-qm30C++rpLtxBhOABBzo+6WILSpKz2ibvUvoe8ku4ow=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libei";
  version = "1.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libinput";
    repo = "libei";
    rev = finalAttrs.version;
    hash = "sha256-fUeMdRK7uoRvgvY3INMorwnTleLrLA5xOeYBFp1qXeI=";
  };

  buildInputs = [
    libevdev
    libxkbcommon
    protobuf
    protobufc
    systemd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (python3.withPackages (
      ps: with ps; [
        attrs
        jinja2
        structlog
      ]
    ))
  ];

  mesonFlags = [
    "-Dtests=disabled"
  ];

  postPatch = ''
    ln -s "${munit}" ./subprojects/munit
    patchShebangs ./proto/ei-scanner
  '';

  meta = {
    description = "Library for Emulated Input";
    mainProgram = "ei-debug-events";
    homepage = "https://gitlab.freedesktop.org/libinput/libei";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
