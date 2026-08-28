{
  stdenv,
  lib,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astyle";
  version = "3.6.16";

  src = fetchurl {
    url = "mirror://sourceforge/astyle/astyle-${finalAttrs.version}.tar.bz2";
    hash = "sha256-QU6dpM/e6zXY98Fw4V70OvX6AGbJ9ZKnRvcHHzVuzac=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # upstream repo includes a build/ directory
  cmakeBuildDir = "_build";

  meta = {
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    mainProgram = "astyle";
    homepage = "https://astyle.sourceforge.net/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
})
