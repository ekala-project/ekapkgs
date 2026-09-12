{
  lib,
  stdenv,
  fetchFromBitbucket,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.1";
  pname = "lrcalc";

  src = fetchFromBitbucket {
    owner = "asbuch";
    repo = "lrcalc";
    rev = "lrcalc-${finalAttrs.version}";
    sha256 = "0s3amf3z75hnrjyszdndrvk4wp5p630dcgyj341i6l57h43d1p4k";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Littlewood-Richardson calculator";
    homepage = "http://math.rutgers.edu/~asbuch/lrcalc/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
