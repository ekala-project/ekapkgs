{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  bison,
  flex,
  libsepol,
  libselinux,
  bzip2,
  audit,
  enablePython ? true,
  swig ? null,
  python3 ? null,
}:

stdenv.mkDerivation rec {
  pname = "libsemanage";
  version = "3.9";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/libsemanage-${version}.tar.gz";
    sha256 = "sha256-7AWFCu9Iv7jgITWn9PP37bo2cPY9XmfycI1L2AuaRjQ=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ]
  ++ lib.optional enablePython "py";

  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ]
  ++ lib.optionals enablePython [
    python3
    swig
  ];

  buildInputs = [
    libsepol
    libselinux
    bzip2
    audit
  ]
  ++ lib.optional enablePython python3;

  makeFlags = [
    "PREFIX=$(out)"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN5DIR=$(man)/share/man/man5"
    "PYTHON=python"
    "PYPREFIX=python"
    "PYTHONLIBDIR=$(py)/${python3.sitePackages}"
    "DEFAULT_SEMANAGE_CONF_LOCATION=$(out)/etc/selinux/semanage.conf"
  ];

  # The following turns the 'clobbered' error into a warning
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=clobbered" ];

  installTargets = [ "install" ] ++ lib.optionals enablePython [ "install-pywrap" ];

  enableParallelBuilding = true;

  meta = removeAttrs libsepol.meta [ "outputsToInstall" ] // {
    description = "Policy management tools for SELinux";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
}
