{
  stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  cmake,
  gtk-doc,
  gtk3,
  libayatana-indicator,
  libdbusmenu,
  vala,
}:

let
  libdbusmenu-gtk3 = libdbusmenu.override { gtkVersion = "3"; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libayatana-appindicator";
  version = "0.5.92";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-appindicator";
    rev = finalAttrs.version;
    sha256 = "sha256-NzaWQBb2Ez1ik23wCgW1ZQh1/rY7GcPlLvaSgV7uXrA=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    gtk-doc
    vala
  ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    libayatana-indicator
    libdbusmenu-gtk3
  ];

  postPatch = ''
    # Disable GIR/typelib generation since gtk3 in ekapkgs doesn't ship .gir files.
    # Remove everything from "find_package(GObjectIntrospection" to end of file in src/CMakeLists.txt
    sed -i '/^find_package(GObjectIntrospection/,$d' src/CMakeLists.txt
  '';

  cmakeFlags = [
    "-DENABLE_BINDINGS_MONO=False"
    "-DENABLE_GTKDOC=False"
    "-DENABLE_BINDINGS_VALA=False"
  ];

  meta = {
    description = "Ayatana Application Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-appindicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-appindicator/blob/${finalAttrs.version}/ChangeLog";
    license = [
      lib.licenses.lgpl3Plus
      lib.licenses.lgpl21Plus
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
