{
  stdenv,
  lib,
  fetchFromGitHub,
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
  version = "2.15.3";

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
    sha256 = "sha256-mmaW0Yxn4c3FxzSbHoFbamQoza15/4hJx3zbMcm3NYw=";
  };

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
  };
})
