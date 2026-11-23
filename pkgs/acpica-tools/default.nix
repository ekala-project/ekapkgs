{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acpica-tools";
  version = "20260930";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "acpica";
    repo = "acpica";
    tag = finalAttrs.version;
    hash = "sha256-sUSikZrofGXMjiYG/5/bQCbtT9uSvM/0eeawZrLrm5M=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildFlags = [
    "acpibin"
    "acpidump"
    "acpiexamples"
    "acpiexec"
    "acpihelp"
    "acpisrc"
    "acpixtract"
    "iasl"
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-O3"
    ];

    NIX_LDFLAGS = lib.optionalString (
      stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
    ) "-no_fixup_chains";

    NOWERROR = "TRUE";

    INSTALLFLAGS = lib.optionalString (!stdenv.hostPlatform.isDarwin) "-m 555";
  };

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://www.acpica.org/";
    description = "ACPICA Tools";
    changelog = "https://github.com/acpica/acpica/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      iasl
      gpl2Only
      bsd3
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
