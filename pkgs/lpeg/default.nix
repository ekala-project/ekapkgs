{
  lib,
  stdenv,
  fetchurl,
  luajit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lpeg";
  version = "1.1.0";

  src = fetchurl {
    url = "https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-${finalAttrs.version}.tar.gz";
    sha256 = "0aimsjpcpkh3kk65f0pg1z2bp6d83rn4dg6pgbx1yv14s9kms5ab";
  };

  buildInputs = [ luajit ];

  postPatch = ''
    substituteInPlace makefile \
      --replace-fail "LUADIR = ./lua/" "LUADIR = ${luajit}/include"
  '';

  buildFlags = [
    "linux"
  ];

  installPhase = ''
    runHook preInstall

    # Install the shared library where neovim's cmake can find it
    install -Dm755 lpeg.so $out/lib/lua/5.1/lpeg.so

    # Also install at top-level lib for cmake find_library
    install -Dm755 lpeg.so $out/lib/lpeg.so

    runHook postInstall
  '';

  meta = {
    description = "Parsing Expression Grammars for Lua";
    homepage = "https://www.inf.puc-rio.br/~roberto/lpeg.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
