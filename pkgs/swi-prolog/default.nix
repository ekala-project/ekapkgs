{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja ? null,

  libxcrypt ? null,
  zlib,
  openssl,
  gmp,
  gperftools,
  libedit,
  libarchive ? null,

  withDb ? false,
  db ? null,

  withJava ? false,
  jdk ? null,

  withOdbc ? false,
  unixodbc ? null,

  withPcre ? true,
  pcre2 ? null,

  withPython ? false,
  python3 ? null,

  withYaml ? true,
  libyaml ? null,

  withGui ? false,
  libxpm ? null,
  libxext ? null,
  libxft ? null,
  libxinerama ? null,
  libjpeg ? null,
  libxt ? null,
  libsm ? null,
  freetype ? null,
  fontconfig ? null,

  withNativeCompiler ? true,

  extraPacks ? [ ],
}:

let
  packInstall = swiplPath: pack: ''
    ${swiplPath}/bin/swipl -g "pack_install(${pack}, [package_directory(\"${swiplPath}/lib/swipl/extra-pack\"), silent(true), interactive(false), git(false)])." -t "halt."
  '';
  optionalDependencies =
    [ ]
    ++ lib.optionals (withDb && db != null) [ db ]
    ++ lib.optionals (withJava && jdk != null) [ jdk ]
    ++ lib.optionals (withOdbc && unixodbc != null) [ unixodbc ]
    ++ lib.optionals (withPcre && pcre2 != null) [ pcre2 ]
    ++ lib.optionals (withPython && python3 != null) [ python3 ]
    ++ lib.optionals (withYaml && libyaml != null) [ libyaml ]
    ++ lib.optionals (withGui && !stdenv.hostPlatform.isDarwin) (
      lib.optionals (libxt != null) [ libxt ]
      ++ lib.optionals (libxext != null) [ libxext ]
      ++ lib.optionals (libxpm != null) [ libxpm ]
      ++ lib.optionals (libxft != null) [ libxft ]
      ++ lib.optionals (libxinerama != null) [ libxinerama ]
      ++ lib.optionals (libjpeg != null) [ libjpeg ]
      ++ lib.optionals (libsm != null) [ libsm ]
      ++ lib.optionals (freetype != null) [ freetype ]
      ++ lib.optionals (fontconfig != null) [ fontconfig ]
    );
in
stdenv.mkDerivation {
  pname = "swi-prolog";
  version = "10.0.2";

  src = fetchFromGitHub {
    owner = "SWI-Prolog";
    repo = "swipl";
    tag = "V10.0.2";
    hash = "sha256-w9BzcnXS2sqHsLXYEcfhZ1niKpifffiDtm8EcJ6cG9g=";
    fetchSubmodules = true;
  };

  postPatch = ''
    echo "user:file_search_path(pack, '$out/lib/swipl/extra-pack')." >> boot/init.pl
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ]
  ++ lib.optionals (ninja != null) [ ninja ];

  buildInputs = [
    zlib
    openssl
    gperftools
    gmp
    libedit
  ]
  ++ lib.optionals (libarchive != null) [ libarchive ]
  ++ lib.optionals (libxcrypt != null) [ libxcrypt ]
  ++ optionalDependencies;

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DSWIPL_INSTALL_IN_LIB=ON"
  ]
  ++ lib.optionals (!withNativeCompiler) [
    "-DSWIPL_CC=gcc"
    "-DSWIPL_CXX=g++"
  ];

  preInstall = ''
    mkdir -p $out/lib/swipl/extra-pack
  '';

  postInstall = builtins.concatStringsSep "\n" (map (packInstall "$out") extraPacks);

  meta = {
    homepage = "https://www.swi-prolog.org";
    description = "Prolog compiler and interpreter";
    license = lib.licenses.bsd2;
    mainProgram = "swipl";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
