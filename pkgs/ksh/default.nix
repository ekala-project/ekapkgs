{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitHub,
  fetchpatch,
  which,
  python3,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksh";
  version = "2020.0.0";

  src = fetchFromGitHub {
    owner = "att";
    repo = "ast";
    sha256 = "0cdxz0nhpq03gb9rd76fn0x1yzs2c8q289b7vcxnzlsrz1imz65j";
    tag = finalAttrs.version;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/att/ast/commit/11983a71f5e29df578b7e2184400728b4e3f451d.patch";
      sha256 = "1n9558c4v2qpgpjb1vafs29n3qn3z0770wr1ayc0xjf5z5j4g3kv";
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    which
    python3
  ];

  buildInputs = [ libiconv ];

  strictDeps = true;

  passthru = {
    shellPath = "/bin/ksh";
  };

  meta = {
    description = "KornShell Command And Programming Language";
    homepage = "https://github.com/att/ast";
    license = lib.licenses.cpl10;
    platforms = lib.platforms.all;
  };
})
