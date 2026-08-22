{
  lib,
  stdenv,
  fetchFromGitHub,
  pcre2,
  openssl,
  zlib,
  libevent,
  inotify-tools,
  systemd,
  file,
  which,
}:

stdenv.mkDerivation rec {
  pname = "ossec";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "ossec";
    repo = "ossec-hids";
    tag = version;
    hash = "sha256-uCf5R0jFyBfcD3FmeLqpR7GStuQN++NCyoNfG1c4am0=";
  };

  buildInputs = [
    pcre2
    openssl
    zlib
    libevent
    inotify-tools
    systemd
    file
  ];

  nativeBuildInputs = [ which ];

  postPatch = ''
    # Fix hardcoded paths
    substituteInPlace src/Makefile \
      --replace-fail '/var/ossec' "$out"
  '';

  buildPhase = ''
    cd src
    make TARGET=local USE_PCRE2=yes USE_OPENSSL=yes PCRE2_SYSTEM=yes ZLIB_SYSTEM=yes PREFIX=$out build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/etc/ossec
    # Binaries are built in the src directory
    for f in ossec-logcollector ossec-syscheckd ossec-analysisd ossec-monitord ossec-agentd \
             ossec-maild ossec-execd ossec-csyslogd ossec-dbd ossec-authd \
             ossec-remoted ossec-agentlessd ossec-regex manage_agents agent-auth; do
      test -f "$f" && install -Dm755 "$f" "$out/bin/$f" || true
    done
    # Install configs
    cp -r ../etc/* $out/etc/ossec/ 2>/dev/null || true
    # Install rules/decoders
    mkdir -p $out/share/ossec
    cp -r ../etc/rules $out/share/ossec/ 2>/dev/null || true
    runHook postInstall
  '';

  meta = {
    description = "Open Source Host-based Intrusion Detection System";
    homepage = "https://www.ossec.net/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
