{
  lib,
  stdenv,
  fetchzip,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i2c-tools";
  version = "4.4";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/i2c-tools/i2c-tools.git/snapshot/i2c-tools-v${finalAttrs.version}.tar.gz";
    sha256 = "sha256-Zm83gxdZH2XQCc/Dihp7vumF9WAvKgt6OORns5Mua7M=";
  };

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace stub/i2c-stub-from-dump \
      --replace "/sbin/" ""
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    rm -rf $out/include/linux/i2c-dev.h # conflicts with kernel headers
  '';

  meta = {
    description = "Set of I2C tools for Linux";
    homepage = "https://i2c.wiki.kernel.org/index.php/I2C_Tools";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
