{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  audiofile,
  libtiff,
  buildPackages,
  autoconf,
  automake,
  libtool,
  libxml2,
  util-linux,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spandsp";
  version = "0.0.6";

  src = fetchurl {
    url = "https://www.soft-switch.org/downloads/spandsp/spandsp-${finalAttrs.version}.tar.gz";
    sha256 = "0rclrkyspzk575v8fslzjpgp4y2s4x7xk3r55ycvpi4agv33l1fc";
  };

  patches = [
    # submitted upstream: https://github.com/freeswitch/spandsp/pull/47
    (fetchpatch {
      url = "https://github.com/freeswitch/spandsp/commit/1f810894804d3fa61ab3fc2f3feb0599145a3436.patch";
      hash = "sha256-Cf8aaoriAvchh5cMb75yP2gsZbZaOLha/j5mq3xlkVA=";
    })

    # https://github.com/freeswitch/spandsp/pull/110
    ./Check-for-feenableexcept-explicitly.patch

    # https://github.com/freeswitch/spandsp/pull/111
    ./Fix-tests-pcap_parse-build-on-musl.patch

    (fetchpatch {
      url = "https://github.com/freeswitch/spandsp/commit/f7b96b08db148763039cf3459d0e00da9636eb92.patch";
      includes = [
        "spandsp-sim/g1050.c"
        "spandsp-sim/test_utils.c"
      ];
      hash = "sha256-2MmVgyMUK0Zn+mL7IX57Y7brYpgmt4GVlis5/NstuNM=";
    })
    (fetchpatch {
      url = "https://github.com/freeswitch/spandsp/commit/f47bcdc301fbddad44e918939eed1b361882f740.patch";
      hash = "sha256-O+lIC3V92GVFoiHsUQOXkoTN2hJ7v5+LQP7RrAhvwlY=";
    })
  ];

  postPatch = ''
    patchShebangs autogen.sh
  ''
  + ''
    substituteInPlace configure.ac \
      --replace-fail '$xml2_include_dir /usr/include /usr/local/include /usr/include/libxml2 /usr/local/include/libxml2' '$xml2_include_dir ${lib.getDev libxml2}/include ${lib.getDev libxml2}/include/libxml2 /usr/local/include/libxml2' \
      --replace-fail 'if test -n "$enable_tests" ; then' 'if test "$enable_tests" = "yes" ; then'
  ''
  + ''
    substituteInPlace test-data/{etsi,itu}/fax/Makefile.am \
      --replace-fail 'nobase_data_DATA' 'noinst_DATA'
  '';

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    util-linux
    which
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  propagatedBuildInputs = [
    audiofile
    libtiff
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--disable-tests"

    # This flag is required to prevent linking error in the cross-compilation case.
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  # Issues with test asset generation under heavy parallelism
  enableParallelBuilding = false;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/cc"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Missing const conversion on some calls
    "-Wno-error=incompatible-pointer-types"
  ];

  hardeningDisable = [
    "format"
  ];

  meta = {
    description = "Portable and modular SIP User-Agent with audio and video support";
    homepage = "https://github.com/freeswitch/spandsp";
    platforms = with lib.platforms; unix;
    license = lib.licenses.gpl2;
    downloadPage = "http://www.soft-switch.org/downloads/spandsp/";
  };
})
