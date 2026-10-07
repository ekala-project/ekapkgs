{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  libsepol,
}:

stdenv.mkDerivation rec {
  pname = "checkpolicy";
  version = "3.11";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/checkpolicy-${version}.tar.gz";
    sha256 = "sha256-m4G/zu9/qdAvmHLlanhvND3FjvS1cT3ODVxBbluEzvo=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];
  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = {
    description = "SELinux policy compiler";
    mainProgram = "checkpolicy";
    homepage = "https://github.com/SELinuxProject/selinux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
