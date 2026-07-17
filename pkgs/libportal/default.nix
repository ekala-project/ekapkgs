{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libportal";
  version = "0.9.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "libportal";
    rev = finalAttrs.version;
    sha256 = "sha256-CXI4rBr9wxLUX537d6SNNf8YFR/J6YdeROlFt3edeOU=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    glib
  ];

  patches = [
    (fetchpatch2 {
      name = "libportal-fix-qt6.9-private-api-usage.patch";
      url = "https://github.com/flatpak/libportal/commit/796053d2eebe4532aad6bd3fd80cdf3b197806ec.patch?full_index=1";
      hash = "sha256-TPIKKnZCcp/bmmsaNlDxAsKLTBe6BKPCTOutLjXPCHQ=";
    })
  ];

  mesonFlags = [
    (lib.mesonEnable "backend-gtk3" false)
    (lib.mesonEnable "backend-gtk4" false)
    (lib.mesonEnable "backend-qt5" false)
    (lib.mesonEnable "backend-qt6" false)
    (lib.mesonBool "vapi" true)
    (lib.mesonBool "introspection" true)
    (lib.mesonBool "docs" true)
  ];

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "Flatpak portal library";
    homepage = "https://github.com/flatpak/libportal";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
