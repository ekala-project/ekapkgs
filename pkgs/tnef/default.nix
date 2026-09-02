{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tnef";
  version = "1.4.18";

  src = fetchFromGitHub {
    owner = "verdammelt";
    repo = "tnef";
    rev = finalAttrs.version;
    sha256 = "104g48mcm00bgiyzas2vf86331w7bnw7h3bc11ib4lp7rz6zqfck";
  };

  patches = [
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://github.com/verdammelt/tnef/commit/86bfa75cfacbe71c8d5282fa0065981b4544c5ad.patch";
      hash = "sha256-iWQop57riqwDLVi5Ba5s4f34lGXgvKO3ZMTgWbAoRIY=";
    })
  ];

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Unpacks MIME attachments of type application/ms-tnef";
    homepage = "https://github.com/verdammelt/tnef";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    mainProgram = "tnef";
  };
})
