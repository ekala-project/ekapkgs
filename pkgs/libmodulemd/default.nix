{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  meson,
  ninja,
  gobject-introspection,
  libyaml,
  rpm,
  file,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmodulemd";
  version = "2.15.0";

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "fedora-modularity";
    repo = "libmodulemd";
    rev = "libmodulemd-${finalAttrs.version}";
    sha256 = "sha256-mIyrdksyEk1AKV+vw4g8LUwlQRzwwMkPDuCbw2IiNcA=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/fedora-modularity/libmodulemd/commit/9d2809090cc0cccd7bab67453dc00cf43a289082.patch";
      hash = "sha256-dMtc6GN6lIDjUReFUhEFJ/8wosASo3tLu4ve72BCXQ8=";
    })
    (fetchpatch2 {
      url = "https://github.com/fedora-modularity/libmodulemd/commit/29c339a31b1c753dcdef041e5c2e0e600e48b59d.patch";
      hash = "sha256-uniHrQdbcXlJk2hq106SgV/E330LfxDc07E4FbOMLr0=";
    })
    (fetchpatch2 {
      url = "https://github.com/fedora-modularity/libmodulemd/commit/f3336199b4e69af3305f156abc7533bed9e9a762.patch";
      hash = "sha256-Rvg+/KTKiEBXVEK7tlcTDf53HkaW462g/rg1rHPzaZA=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
    gobject-introspection
  ];

  buildInputs = [
    libyaml
    rpm
    file
    glib
  ];

  mesonFlags = [
    "-Dwith_py3=false"
  ];

  postPatch = ''
    substituteInPlace meson.build --replace-fail \
      "glib_docpath = join_paths(glib_prefix," "glib_docpath = join_paths('${lib.getOutput "devdoc" glib}',"
  '';

  meta = {
    description = "C Library for manipulating module metadata files";
    mainProgram = "modulemd-validator";
    homepage = "https://github.com/fedora-modularity/libmodulemd";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
})
