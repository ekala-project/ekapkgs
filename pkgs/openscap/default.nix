{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsepol,
  popt,
  libxml2,
  libxslt,
  openssl,
  util-linux,
  pcre2,
  libselinux,
  graphviz,
  glib,
  python3,
  swig,
  libgcrypt,
  opendbx,
  xmlbird,
  haskellPackages,
  libyaml,
  yaml-filter ? null,
  xmlsec,
  bzip2,
  valgrind,
  asciidoc,
  installShellFiles,
  makeWrapper,
  rpm,
  system-sendmail,
  curl,
  procps,
  systemdLibs,
  perl,
  doxygen,
  pkg-config,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openscap";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "OpenSCAP";
    repo = "openscap";
    tag = finalAttrs.version;
    hash = "sha256-AOldgYS8qMOLB/Nm2/O0obdDOrefSrubTETb50f3Gv8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    asciidoc
    doxygen
    makeWrapper
    rpm
    swig
    util-linux
    pkg-config
  ];

  buildInputs = [
    perl
    popt
    openssl
    valgrind
    pcre2
    libxslt
    xmlsec
    libselinux
    libyaml
    xmlbird
    installShellFiles
    bzip2
    yaml-filter
    python3
    libgcrypt
    libxml2
    systemdLibs
    haskellPackages.pthread
    graphviz
    system-sendmail
    procps
    libsepol
    curl
    glib
    opendbx
  ];

  prePatch = ''
    export SWIG_PERL_DIR=lib/perl
    substituteInPlace swig/perl/CMakeLists.txt \
      --replace-fail "DESTINATION ''${PERL_VENDORLIB}" "DESTINATION ''${SWIG_PERL_DIR}''${PERL_VERSION}" \
      --replace-fail "DESTINATION ''${PERL_VENDORARCH}" "DESTINATION ''${SWIG_PERL_DIR}"
    substituteInPlace src/common/oscap_pcre.c \
      --replace-fail "#include <pcre2.h>" "#include <${pcre2}/include/pcre2.h>"

    # Patch SCE engine to not hardcode FHS paths, allowing it to use the transient environment's PATH
    substituteInPlace src/SCE/sce_engine.c \
      --replace-fail 'env_values[0] = "PATH=/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin";' 'env_values[0] = "_PATCHED_OUT_DUMMY_VAR=patched-out";'
  '';

  cmakeEntries = {
    PCRE2_INCLUDE_DIRS = "${pcre2}/include";
    PCRE2_LIBRARIES = "${pcre2}/lib";
    ENABLE_DOCS = true;
    ENABLE_TESTS = true;
    ENABLE_OSCAP_UTIL = true;
    ENABLE_OSCAP_UTIL_CHROOT = true;
    ENABLE_OSCAP_UTIL_SSH = true;
    ENABLE_OSCAP_UTIL_DOCKER = true;
    ENABLE_OSCAP_REMEDIATE_SERVICE = true;
    OPENSCAP_PROBE_INDEPENDENT_YAMLFILECONTENT = true;
    SYSTEMD_UNITDIR = "lib/systemd/system";
    ENABLE_VALGRIND = true;
    PYTHON_SITE_PACKAGES_INSTALL_DIR = "${python3.pkgs.python.sitePackages}";
    OPENSCAP_INSTALL_DESTINATION = "bin";
    CMAKE_INSTALL_BINDIR = "bin";
    CMAKE_INSTALL_MANDIR = "share";
    ENABLE_MITRE = true;
    CMAKE_INSTALL_LIBDIR = "lib";
    CMAKE_INSTALL_INCLUDEDIR = "include";
    CMAKE_INSTALL_DATADIR = "share";
    BUILD_TESTING = true;
    CMAKE_EXPORT_NO_PACKAGE_REGISTRY = true;
    CMAKE_POLICY_DEFAULT_CMP0025 = "NEW";
  };

  postBuild = ''
    make $makeFlags docs
  '';

  installPhase = ''
    make install
    installManPage $out/share/man8/*.8
    rm -rf $out/share/man8
  '';

  postFixup = ''
    # Set plugin directory to discover the SCE plugin.
    # openscap calls dlopen with this as the directory prefix.
    wrapProgram $out/bin/oscap \
      --set OSCAP_CHECK_ENGINE_PLUGIN_DIR $out/lib
  '';

  meta = {
    description = "NIST Certified SCAP 1.2 toolkit";
    homepage = "https://github.com/OpenSCAP/openscap";
    changelog = "https://github.com/OpenSCAP/openscap/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.lgpl21Only;
    mainProgram = "oscap";
    platforms = lib.platforms.linux;
  };
})
