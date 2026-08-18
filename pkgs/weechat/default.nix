{
  stdenv,
  fetchurl,
  lib,
  ncurses,
  openssl,
  cjson,
  gnutls,
  gettext,
  zlib,
  curl,
  pkg-config,
  libgcrypt,
  cmake,
  asciidoctor,
  enableTests ? true,
  cpputest,
  guileSupport ? true,
  guile,
  luaSupport ? true,
  lua5_3,
  perlSupport ? true,
  perl,
  pythonSupport ? true,
  python3Packages,
  rubySupport ? true,
  ruby,
  tclSupport ? true,
  tcl,
  phpSupport ? false,
  php ? null,
  systemdLibs,
  libxml2,
  pcre2,
  libargon2,
  extraBuildInputs ? [ ],
}:

let
  inherit (python3Packages) python;
  php-embed = php.override {
    embedSupport = true;
    apxs2Support = false;
  };
  plugins = [
    {
      name = "perl";
      enabled = perlSupport;
      cmakeFlag = "ENABLE_PERL";
      buildInputs = [ perl ];
    }
    {
      name = "tcl";
      enabled = tclSupport;
      cmakeFlag = "ENABLE_TCL";
      buildInputs = [ tcl ];
    }
    {
      name = "ruby";
      enabled = rubySupport;
      cmakeFlag = "ENABLE_RUBY";
      buildInputs = [ ruby ];
    }
    {
      name = "guile";
      enabled = guileSupport;
      cmakeFlag = "ENABLE_GUILE";
      buildInputs = [ guile ];
    }
    {
      name = "lua";
      enabled = luaSupport;
      cmakeFlag = "ENABLE_LUA";
      buildInputs = [ lua5_3 ];
    }
    {
      name = "python";
      enabled = pythonSupport;
      cmakeFlag = "ENABLE_PYTHON3";
      buildInputs = [ python ];
    }
    {
      name = "php";
      enabled = phpSupport;
      cmakeFlag = "ENABLE_PHP";
      buildInputs = [
        php-embed.unwrapped.dev
        libxml2
        pcre2
        libargon2
        systemdLibs
      ];
    }
  ];
  enabledPlugins = builtins.filter (p: p.enabled) plugins;
in

assert lib.all (p: p.enabled -> !(builtins.elem null p.buildInputs)) plugins;

stdenv.mkDerivation rec {
  pname = "weechat";
  version = "4.10.0";

  src = fetchurl {
    url = "https://weechat.org/files/src/weechat-${version}.tar.xz";
    hash = "sha256-w6fnxqVAHd6aRtAmT6RKowMsqYqoZBDEVNPeXGlQXFQ=";
  };

  patches = lib.optionals gettext.gettextNeedsLdflags [
    ./gettext-intl.patch
  ];

  outputs = [
    "out"
    "man"
  ]
  ++ map (p: p.name) enabledPlugins;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_MAN" true)
    (lib.cmakeBool "ENABLE_DOC" true)
    (lib.cmakeBool "ENABLE_DOC_INCOMPLETE" true)
    (lib.cmakeBool "ENABLE_TESTS" enableTests)
    (lib.cmakeBool "ENABLE_SPELL" false)
  ]
  ++ map (p: lib.cmakeBool p.cmakeFlag p.enabled) plugins;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    asciidoctor
  ]
  ++ lib.optionals enableTests [ cpputest ];

  buildInputs = [
    ncurses
    openssl
    cjson
    gnutls
    gettext
    zlib
    curl
    libgcrypt
  ]
  ++ lib.concatMap (p: p.buildInputs) enabledPlugins
  ++ extraBuildInputs;

  env.NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}";

  postInstall = ''
    for p in ${lib.concatMapStringsSep " " (p: p.name) enabledPlugins}; do
      from=$out/lib/weechat/plugins/$p.so
      to=''${!p}/lib/weechat/plugins/$p.so
      mkdir -p $(dirname $to)
      mv $from $to
    done
  '';

  meta = {
    homepage = "https://weechat.org/";
    changelog = "https://github.com/weechat/weechat/releases/tag/v${version}";
    description = "Fast, light and extensible chat client";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    mainProgram = "weechat";
    platforms = lib.platforms.unix;
  };
}
