{
  lib,
  stdenv,
  fetchurl,
  cmake,
  recode,
  perl,
  rinutils,
  fortune,
  libxslt,
  docbook-xsl-nons,
  withOffensive ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fortune-mod";
  version = "3.26.0";

  # We use fetchurl instead of fetchFromGitHub because the release pack has some
  # special files.
  src = fetchurl {
    url = "https://github.com/shlomif/fortune-mod/releases/download/fortune-mod-${finalAttrs.version}/fortune-mod-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-rE0UhsrJuZkEkQcTa5QQb+mKSurADsY1sUTEN2S//kw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    (perl.withPackages (p: [
      p.PathTiny
    ]))
    rinutils
    libxslt
    docbook-xsl-nons
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # "strfile" must be in PATH for cross-compiling builds.
    fortune
  ];

  buildInputs = [ recode ];

  cmakeFlags = [
    "-DLOCALDIR=${placeholder "out"}/share/fortunes"
    "-DDISABLE_RECODE=false"
  ]
  ++ lib.optional (!withOffensive) "-DNO_OFFENSIVE=true";

  postPatch = ''
    # Remove man page generation which requires docmake (AppXMLDocBookBuilder perl module)
    perl -0777 -i -pe 's/SET \(_my_man_page_dir.*?ADD_CUSTOM_TARGET\(\s*generate_man_page\s+ALL DEPENDS[^)]*\)/# Man page generation removed/s' CMakeLists.txt
  '';

  patches = [
    (builtins.toFile "not-a-game.patch" ''
      diff --git a/CMakeLists.txt b/CMakeLists.txt
      index 865e855..5a59370 100644
      --- a/CMakeLists.txt
      +++ b/CMakeLists.txt
      @@ -154,7 +154,7 @@ ENDMACRO()
       my_exe(
           "fortune"
           "fortune/fortune.c"
      -    "games"
      +    "bin"
       )

       my_exe(
      --
    '')
  ];

  postFixup = lib.optionalString (!withOffensive) ''
    rm $out/share/games/fortunes/men-women*
  '';

  meta = {
    mainProgram = "fortune";
    description = "Program that displays a pseudorandom message from a database of quotations";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.unix;
  };
})
