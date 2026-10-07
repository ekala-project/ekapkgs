{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  pkg-config,
  curl,
  geoip,
  libmaxminddb,
  libxml2,
  lmdb,
  lua,
  pcre2,
  ssdeep,
  yajl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "modsecurity";
  version = "3.0.17";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = "ModSecurity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OebDDhaOQfOf22MoQ1htHwB25O52OnJBSzZlxhnJ0Zo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    curl
    geoip
    libmaxminddb
    libxml2
    lmdb
    lua
    pcre2
    ssdeep
    yajl
  ];

  configureFlags = [
    "--enable-parser-generation"
    "--disable-doxygen-doc"
    "--disable-examples"
    "--with-lmdb=${lmdb}"
    "--with-ssdeep=${ssdeep}"
  ];

  postPatch = ''
    # https://github.com/owasp-modsecurity/ModSecurity/blob/v3.0.15/build.sh#L6-L25
    echo "noinst_HEADERS = \\" > ./src/headers.mk
    ls -1 ./src/ \
        actions/*.h \
        actions/ctl/*.h \
        actions/data/*.h \
        actions/disruptive/*.h \
        actions/transformations/*.h \
        debug_log/*.h \
        audit_log/writer/*.h \
        collection/backend/*.h \
        operators/*.h \
        parser/*.h \
        request_body_processor/*.h \
        utils/*.h \
        variables/*.h \
        engine/*.h \
        *.h | tr "\012" " " >> ./src/headers.mk

    substituteInPlace modsecurity.conf-recommended \
      --replace-fail "SecUnicodeMapFile unicode.mapping 20127" "SecUnicodeMapFile $out/share/modsecurity/unicode.mapping 20127"
  '';

  postInstall = ''
    mkdir -p $out/share/modsecurity
    cp ${finalAttrs.src}/{AUTHORS,CHANGES,LICENSE,README.md,modsecurity.conf-recommended,unicode.mapping} $out/share/modsecurity
  '';

  meta = {
    description = "Open source, cross-platform web application firewall (WAF)";
    license = lib.licenses.asl20;
    homepage = "https://github.com/owasp-modsecurity/ModSecurity";
    platforms = lib.platforms.linux;
    mainProgram = "modsec-rules-check";
  };
})
