{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  callPackage,
  autoreconfHook,
  pkg-config,
  libtool,
  bison,
  flex,
  perl,
  enabledPlugins ? null,
}:
let
  plugins = callPackage ./plugins.nix {
    inherit enabledPlugins;
    iptables = null;
    libpcap = null;
    libvirt = null;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "collectd";
  version = "5.12.0";

  src = fetchFromGitHub {
    owner = "collectd";
    repo = "collectd";
    tag = "collectd-${finalAttrs.version}";
    hash = "sha256-UTlCY1GPRpbdQFLFUDjNr1PgEdGv4WNtjr8TYbxHK5A=";
  };

  patches = [
    (fetchpatch {
      name = "fix-broken-dash-t-option.patch";
      url = "https://github.com/collectd/collectd/commit/3f575419e7ccb37a3b10ecc82adb2e83ff2826e1.patch";
      hash = "sha256-XkDxLITmG0FLpgf8Ut1bDqulM4DmPs8Xrec2QB1tkks=";
    })
    (fetchpatch {
      name = "no_include_longintrepr.patch";
      url = "https://github.com/collectd/collectd/commit/623e95394e0e62e7f9ced2104b786d21e9c0bf53.patch";
      hash = "sha256-0eD7yNW3TWVyNMpLsADhYFDvy6COoCaI0kS1XJrwDgM=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    bison
    flex
    perl
  ];

  buildInputs = [
    libtool
  ]
  ++ plugins.buildInputs;

  configureFlags = [
    "--localstatedir=/var"
    "--disable-werror"
  ]
  ++ plugins.configureFlags
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "--with-fp-layout=nothing" ];

  env.NIX_CFLAGS_COMPILE = "-DATTRIBUTE_UNUSED=__attribute__((unused))";

  postConfigure = ''
    substituteInPlace Makefile --replace-fail '$(mkinstalldirs) $(DESTDIR)$(localstatedir)/' '#'
  '';

  postInstall = ''
    if [ -d $out/share/collectd/java ]; then
      mv $out/share/collectd/java $out/share/
    fi
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Daemon which collects system performance statistics periodically";
    homepage = "https://collectd.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
