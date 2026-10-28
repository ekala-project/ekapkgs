{
  lib,
  stdenv,
  buildPackages,
  pkg-config,
  fetchurl,
  libedit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dash";
  version = "0.5.13.5";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/dash-${finalAttrs.version}.tar.gz";
    hash = "sha256-QAkBAaKkkfE+kB09SOkEFPJmNGKLm//zX/VANjwien0=";
  };

  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isStatic [ pkg-config ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ libedit ];

  hardeningDisable = [ "strictflexarrays3" ];

  configureFlags = [ "--with-libedit" ];
  preConfigure = lib.optionalString stdenv.hostPlatform.isStatic ''
    export LIBS="$(''${PKG_CONFIG:-pkg-config} --libs --static libedit)"
  '';

  passthru.shellPath = "/bin/dash";

  meta = {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
    mainProgram = "dash";
  };
})
