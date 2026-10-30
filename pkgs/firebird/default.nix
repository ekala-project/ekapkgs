{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cmake,
  libedit,
  zlib,
  unzip,
  libtommath,
  libtomcrypt,
  icu,

  superServer ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "firebird";
  version = "5.0.4";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "FirebirdSQL";
    repo = "firebird";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-IJrfs8q7GtX4Y+Cmg4avT5QJmLpld38tyR3TR1CcgyE=";
  };

  # CMake is just used for libcds
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    autoreconfHook
    cmake
    unzip
  ];

  buildInputs = [
    libedit
    icu
    zlib
    libtommath
    libtomcrypt
  ];

  env.LD_LIBRARY_PATH = lib.makeLibraryPath [ icu ];

  configureFlags = [
    "--with-system-editline"
  ]
  ++ lib.optional superServer "--enable-superserver";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r gen/Release/firebird/* $out
    rm -f $out/lib/*.a  # they were just symlinks to /build/source/...
    runHook postInstall
  '';

  meta = {
    description = "SQL relational database management system";
    downloadPage = "https://github.com/FirebirdSQL/firebird/";
    homepage = "https://firebirdsql.org/";
    changelog = "https://github.com/FirebirdSQL/firebird/blob/master/CHANGELOG.md";
    license = with lib.licenses; [
      mpl11
      interbase
    ];
    platforms = lib.platforms.linux;
  };
})
