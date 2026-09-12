{
  lib,
  stdenv,
  fetchFromGitHub,
  popt,
  avahi,
  pkg-config,
  python3,
  gtk3,
  runCommand,
  gcc,
  autoconf,
  automake,
  which,
  procps,
  libiberty,
  runtimeShell,
  sysconfDir ? "",
  static ? false,
}:

let
  pname = "distcc";
  version = "3.4";
  libiberty_static = libiberty.override { staticBuild = true; };
  distcc = stdenv.mkDerivation {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "distcc";
      repo = "distcc";
      tag = "v${version}";
      hash = "sha256-S3EHJ8s+bYWBmOfKP5ErNSa+UIalIK82MgKhWvPnwFo=";
    };

    nativeBuildInputs = [
      pkg-config
      autoconf
      automake
      which
      (python3.withPackages (p: [ p.setuptools ]))
    ];
    buildInputs = [
      popt
      avahi
      gtk3
      procps
      libiberty_static
    ];
    preConfigure = ''
      export CPATH=$(ls -d ${gcc.cc}/lib/gcc/*/${gcc.cc.version}/plugin/include)

      configureFlagsArray=( CFLAGS="-O2 -fno-strict-aliasing"
                            CXXFLAGS="-O2 -fno-strict-aliasing"
          --mandir=$out/share/man
                            ${lib.optionalString (sysconfDir != "") "--sysconfdir=${sysconfDir}"}
                            ${lib.optionalString static "LDFLAGS=-static"}
                            ${lib.withFeature (static == true || popt == null) "included-popt"}
                            ${lib.withFeature (avahi != null) "avahi"}
                            ${lib.withFeature (gtk3 != null) "gtk"}
                            --without-gnome
                            --enable-rfc2553
                            --disable-Werror
                           )
      installFlags="sysconfdir=$out/etc";

      ./autogen.sh
    '';

    doCheck = false;

    passthru = {
      # A derivation that provides gcc and g++ commands, but that
      # will end up calling distcc for the given cacheDir
      #
      # extraConfig is meant to be sh lines exporting environment
      # variables like DISTCC_HOSTS, DISTCC_DIR, ...
      links =
        extraConfig:
        (runCommand "distcc-links" { passthru.gcc = gcc.cc; } ''
          mkdir -p $out/bin
          if [ -x "${gcc.cc}/bin/gcc" ]; then
            cat > $out/bin/gcc << EOF
            #!${runtimeShell}
            ${extraConfig}
            exec ${distcc}/bin/distcc gcc "\$@"
          EOF
            chmod +x $out/bin/gcc
          fi
          if [ -x "${gcc.cc}/bin/g++" ]; then
            cat > $out/bin/g++ << EOF
            #!${runtimeShell}
            ${extraConfig}
            exec ${distcc}/bin/distcc g++ "\$@"
          EOF
            chmod +x $out/bin/g++
          fi
        '');
    };

    meta = {
      description = "Fast, free distributed C/C++ compiler";
      homepage = "http://distcc.org";
      license = lib.licenses.gpl2Only;
      mainProgram = "distcc";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };
in
distcc
