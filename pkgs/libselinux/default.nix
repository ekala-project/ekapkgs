{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pcre2,
  pkg-config,
  libsepol,
  python3,
  fts,
  patchutils_0_3_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libselinux";
  version = "3.8.1";
  inherit (libsepol) se_url;

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/libselinux-${finalAttrs.version}.tar.gz";
    hash = "sha256-7C0nifkxFS0hwdsetLwgLOTszt402b6eNg47RSQ87iw=";
  };

  patches = [
    (fetchurl {
      url = "https://lore.kernel.org/selinux/20250211211651.1297357-3-hi@alyssa.is/raw";
      hash = "sha256-a0wTSItj5vs8GhIkfD1OPSjGmAJlK1orptSE7T3Hx20=";
      postFetch = ''
        mv "$out" $TMPDIR/patch
        ${buildPackages.patchutils_0_3_3}/bin/filterdiff \
            -i 'a/libselinux/*' --strip 1 <$TMPDIR/patch >"$out"
      '';
    })

    (fetchurl {
      url = "https://git.yoctoproject.org/meta-selinux/plain/recipes-security/selinux/libselinux/0003-libselinux-restore-drop-the-obsolete-LSF-transitiona.patch?id=62b9c816a5000dc01b28e78213bde26b58cbca9d";
      hash = "sha256-RiEUibLVzfiRU6N/J187Cs1iPAih87gCZrlyRVI2abU=";
    })

    ./fix-build-32bit-lfs.patch
  ];

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libsepol
    pcre2
  ]
  ++ lib.optionals (fts != null) [ fts ];

  # drop fortify here since package uses it by default, leading to compile error:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
  hardeningDisable = [ "fortify" ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error -D_FILE_OFFSET_BITS=64";
  }
  //
    lib.optionalAttrs (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17")
      {
        NIX_LDFLAGS = "--undefined-version";
      };

  makeFlags = [
    "PREFIX=$(out)"
    "INCDIR=$(dev)/include/selinux"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN5DIR=$(man)/share/man/man5"
    "MAN8DIR=$(man)/share/man/man8"
    "SBINDIR=$(bin)/sbin"
    "SHLIBDIR=$(out)/lib"

    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ]
  ++ lib.optionals (fts != null) [
    "FTS_LDLIBS=-lfts"
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [
    "DISABLE_SHARED=y"
  ];

  meta = removeAttrs libsepol.meta [ "outputsToInstall" ] // {
    description = "SELinux core library";
    maintainers = [ ];
  };
})
