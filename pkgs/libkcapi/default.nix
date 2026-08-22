{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  buildPackages,
  kcapi-test ? true,
  kcapi-speed ? true,
  kcapi-hasher ? true,
  kcapi-rngapp ? true,
  kcapi-encapp ? true,
  kcapi-dgstapp ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkcapi";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "libkcapi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xOI29cjhUGUeHLaYIrPA5ZwwCE9lBdZG6kaW0lo1uL8=";
  };

  outputs = [
    "out"
  ]
  ++ lib.optionals kcapi-test [
    "selftests"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  configureFlags =
    lib.optional kcapi-test "--enable-kcapi-test"
    ++ lib.optional kcapi-speed "--enable-kcapi-speed"
    ++ lib.optional kcapi-hasher "--enable-kcapi-hasher"
    ++ lib.optional kcapi-rngapp "--enable-kcapi-rngapp"
    ++ lib.optional kcapi-encapp "--enable-kcapi-encapp"
    ++ lib.optional kcapi-dgstapp "--enable-kcapi-dgstapp";

  postInstall = lib.optionalString kcapi-test ''
    mkdir -p $selftests/bin
    find $out -iname '*.sh' -exec mv {} $selftests/bin/ \;
  '';

  meta = {
    homepage = "http://www.chronox.de/libkcapi.html";
    description = "Linux Kernel Crypto API User Space Interface Library";
    license = with lib.licenses; [
      bsd3
      gpl2Only
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
