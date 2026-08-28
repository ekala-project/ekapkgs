{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  fetchDebianPatch,
  fetchpatch2,
  flex,
  gtk3,
  intltool,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "galculator";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "galculator";
    repo = "galculator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XLDQdUGin7b9SgYV1kwMChBF+l0mYc9sAscY4YRZEGA=";
  };

  patches = [
    (fetchpatch2 {
      name = "fno-common.patch";
      url = "https://github.com/galculator/galculator/commit/501a9e3feeb2e56889c0ff98ab6d0ab20348ccd6.patch";
      hash = "sha256-qVJHcfJTtl0hK8pzSp6MjhYAh1NbIIWr3rBDodIYBvk=";
    })
    ./gettext-0.25.patch
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      patch = "0002-Declare-function-parameters-as-required-by-C23.patch";
      debianRevision = "2.1";
      hash = "sha256-kwRYYNOo3Z2SjFQzR6Mo+qBgW3LQfhxdE6mMpLGoE44=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    flex
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
  ];

  strictDeps = false;

  meta = {
    homepage = "https://galculator.sourceforge.net/";
    description = "GTK algebraic and RPN calculator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "galculator";
    inherit (gtk3.meta) platforms;
  };
})
