{
  lib,
  stdenv,
  fetchurl,
  which,
  dieHook ? null,
  bmake,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableDarwinSandbox ? true,
}:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "3.0.1";

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "fe68e1b7ff23f3992398356d7aa9a330dfd7b72e22bea9a91eeef74182b209ecea0c9f3e2b2216e1a07b2358da2b746238ec9cbbdeebdd3551cef14dd2d79f46";
  };

  patches = [ ./fix-cygwin-build.patch ];

  nativeBuildInputs = [
    which
    bmake
  ]
  ++ lib.optionals (dieHook != null) [ dieHook ];

  configurePhase = ''
    runHook preConfigure
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                LIBDIR=''${!outputLib}/lib \
                MANDIR=''${!outputMan}/share/man
    runHook postConfigure
  '';

  makeFlags = [
    "bins"
  ];

  installTargets = [
    "install"
  ]
  ++ lib.optionals enableShared [
    "install_shared"
  ]
  ++ lib.optionals enableStatic [
    "install_static"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    echo '# TEST' > test.md
    $out/bin/lowdown test.md | grep '[hH]1'
    runHook postInstallCheck
  '';

  doCheck = true;
  checkTarget = "regress";

  meta = {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
