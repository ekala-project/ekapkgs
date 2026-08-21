{
  stdenv,
  lib,
  pkg-config,
  jansson,
  pcre,
  libxcrypt,
  expat,
  zlib,
  pam,
  systemd,
  libcap,
  python3,
  ncurses,
  makeWrapper,
  fetchFromGitHub,
}:

let
  withPAM = stdenv.hostPlatform.isLinux;
  withSystemd = stdenv.hostPlatform.isLinux;
  withCap = stdenv.hostPlatform.isLinux;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "uwsgi";
  version = "2.0.29";

  src = fetchFromGitHub {
    owner = "unbit";
    repo = "uwsgi";
    tag = finalAttrs.version;
    hash = "sha256-WlbvvAu+A0anPItnG8RnWrXm450/xbOloPzUd2L9TuU=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    jansson
    pcre
    libxcrypt
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    expat
    zlib
  ]
  ++ lib.optional withPAM pam
  ++ lib.optional withSystemd systemd
  ++ lib.optional withCap libcap;

  basePlugins = lib.concatStringsSep "," (
    lib.optional withPAM "pam" ++ lib.optional withSystemd "systemd_logger"
  );

  UWSGI_INCLUDES = lib.optionalString withCap "${libcap.dev}/include";

  postPatch = ''
    for f in uwsgiconfig.py plugins/*/uwsgiplugin.py; do
      substituteInPlace "$f" \
        --replace pkg-config "$PKG_CONFIG"
    done
  '';

  configurePhase = ''
    runHook preConfigure

    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p $pluginDir
    python3 uwsgiconfig.py --build nixos

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 uwsgi $out/bin/uwsgi

    runHook postInstall
  '';

  meta = {
    description = "Fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    homepage = "https://uwsgi-docs.readthedocs.org/en/latest/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "uwsgi";
  };
})
