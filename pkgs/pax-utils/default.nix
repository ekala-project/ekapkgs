{
  stdenv,
  lib,
  fetchgit,
  buildPackages,
  docbook_xml_dtd_44,
  docbook_xsl,
  withFuzzing ? stdenv.hostPlatform.isLinux,
  withLibcap ? stdenv.hostPlatform.isLinux,
  libcap,
  pkg-config,
  meson,
  ninja,
  xmlto,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pax-utils";
  version = "1.3.11";

  src = fetchgit {
    url = "https://anongit.gentoo.org/git/proj/pax-utils.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eeWu8XKBAq6U5K5a93BZYGFGfz2R8ysW/VaCyjN0Um8=";
  };

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "use_fuzzing" withFuzzing)
    (lib.mesonEnable "use_libcap" withLibcap)
    (lib.mesonBool "use_seccomp" false)
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    docbook_xml_dtd_44
    docbook_xsl
    meson
    ninja
    pkg-config
    xmlto
  ];
  buildInputs = lib.optionals withLibcap [ libcap ];
  propagatedBuildInputs = [ (python3.withPackages (p: with p; [ pyelftools ])) ];

  meta = {
    description = "ELF utils that can check files for security relevant properties";
    homepage = "https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
