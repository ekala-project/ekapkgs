{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dhcping";
  version = "1.2";

  src = fetchurl {
    sha256 = "0sk4sg3hn88n44dxikipf3ggfj3ixrp22asb7nry9p0bkfaqdvrj";
    url = "https://www.mavetju.org/download/dhcping-${finalAttrs.version}.tar.gz";
  };

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Send DHCP request to find out if a DHCP server is running";
    homepage = "http://www.mavetju.org/unix/general.php";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    mainProgram = "dhcping";
  };
})
