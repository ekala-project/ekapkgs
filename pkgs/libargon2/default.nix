{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libargon2";
  version = "20190702";

  src = fetchFromGitHub {
    owner = "P-H-C";
    repo = "phc-winner-argon2";
    rev = finalAttrs.version;
    sha256 = "0p4ry9dn0mi9js0byijxdyiwx74p1nr8zj7wjpd1fjgqva4sk23i";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/P-H-C/phc-winner-argon2/commit/cd1c1d8d204e4ec4557e358013567c097cb70562.patch";
      sha256 = "0whqv8b6q9602n7vxpzbd8bk8wz22r1jz9x5lrm9z7ib3wz81c8a";
    })
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
    "PREFIX=${placeholder "out"}"
    "ARGON2_VERSION=${finalAttrs.version}"
    "LIBRARY_REL=lib"
    "PKGCONFIG_REL=lib"
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [
    "LIBRARIES=$(LIB_ST)"
    "LINKED_LIB_EXT="
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Key derivation function that was selected as the winner of the Password Hashing Competition in July 2015";
    homepage = "https://www.argon2.com/";
    license = with lib.licenses; [
      asl20
      cc0
    ];
    mainProgram = "argon2";
    platforms = lib.platforms.all;
  };
})
