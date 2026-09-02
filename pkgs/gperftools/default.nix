{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  libunwind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gperftools";
  version = "2.18.1";

  src = fetchFromGitHub {
    owner = "gperftools";
    repo = "gperftools";
    tag = "gperftools-${finalAttrs.version}";
    hash = "sha256-LvLsq0UuMu51vcgxDrBkdnoUJ3qFH+tbXbTjreBxBqs=";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gperftools/raw/88ce8ee43a12b1a8146781a1b4d9abbd8df8af0e/f/gperftools-2.17-disable-generic-dynamic-tls.patch";
      hash = "sha256-IOLUf9mCEA+fVSJKU94akcnXTIm7+t+S9cjBHsEDwFA=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optional (
    stdenv.hostPlatform.isLinux && !(stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isStatic)
  ) libunwind;

  configureFlags = lib.optional stdenv.hostPlatform.isAarch "--disable-general-dynamic-tls";

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile.am --replace stdc++ c++
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_XOPEN_SOURCE";

  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/gperftools/gperftools";
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})
