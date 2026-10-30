{
  lib,
  beamPackages,
  stdenv,
  fetchurl,
  python3,
  libxml2,
  libxslt,
  git,
  xmlto,
  docbook-xml-dtd,
  docbook_xsl,
  zip,
  unzip,
  rsync,
  getconf,
  socat,
  procps,
  coreutils,
  sed,
  systemd,
  glibcLocales,
  which,
  p7zip,
}:

let
  runtimePath = lib.makeBinPath (
    [
      beamPackages.erlang
      getconf # for getting memory limits
      socat
      sed
      coreutils # used by helper scripts
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      procps # the built-in macOS version has extra entitlements to read rss
      systemd # for systemd unit activation check
    ]
  );

in

stdenv.mkDerivation (finalAttrs: {
  pname = "rabbitmq-server";
  version = "4.3.1";

  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-LqNnrbMO5dZDnU2e4yMhP/duePh6ETN1AUcqn7+53t4=";
  };

  nativeBuildInputs = [
    unzip
    xmlto
    docbook-xml-dtd.v4_5
    docbook_xsl
    zip
    rsync
    python3
    which
    p7zip
  ];

  buildInputs = [
    beamPackages.erlang
    beamPackages.elixir
    libxml2
    libxslt
    glibcLocales
  ];

  prePatch = ''
    # erlang.mk assumes that the elixir lib directory is at the same level as the bin of the elixir binary,
    # this is not for the Nixpkgs packaging, so patch this
    substituteInPlace erlang.mk \
      --replace-fail \
      "ELIXIR_LIBS ?= $(abspath $(dir $(ELIXIR_BIN))/../lib)" \
      "ELIXIR_LIBS ?= ${beamPackages.elixir}/lib/elixir/lib"
  '';

  outputs = [
    "out"
    "man"
    "doc"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "RMQ_ERLAPP_DIR=$(out)"
  ];

  installTargets = [
    "install"
    "install-man"
  ];

  preBuild = ''
    export LANG=C.UTF-8 # fix elixir locale warning
    export PROJECT_VERSION="$version"
  '';

  postInstall = ''
    # rabbitmq-env calls to sed/coreutils, so provide everything early
    sed -i $out/sbin/rabbitmq-env -e '2s|^|PATH=${runtimePath}\''${PATH:+:}\$PATH/\n|'

    # We know exactly where rabbitmq is gonna be, so we patch that into the env-script.
    # By doing it early we make sure that auto-detection for this will
    # never be executed (somewhere below in the script).
    sed -i $out/sbin/rabbitmq-env -e "2s|^|RABBITMQ_SCRIPTS_DIR=$out/sbin\n|"

    # there's a few stray files that belong into share
    mkdir -p $doc/share/doc/rabbitmq-server
    mv $out/LICENSE* $doc/share/doc/rabbitmq-server

    # and an unecessarily copied INSTALL file
    rm $out/INSTALL
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    out="$(env - LANG=C.utf8 HOME=$TMPDIR $(out)/bin/rabbitmqctl version)"
    if [[ "$out" != "$version" ]]; then
      echo "Rabbitmq should report version $version, but thinks it's version $out" >&2
      exit 1
    fi
    runHook postInstallCheck
  '';

  passthru = {
    # TODO(ekaos): replace with integrationTests
    # tests = { vm-test = nixosTests.rabbitmq; };
  };

  meta = {
    homepage = "https://www.rabbitmq.com/";
    description = "Implementation of the AMQP messaging protocol";
    changelog = "https://github.com/rabbitmq/rabbitmq-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
  };
})
