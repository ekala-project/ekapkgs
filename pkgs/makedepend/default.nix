{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "makedepend";
  version = "1.0.9";

  src = fetchurl {
    url = "mirror://xorg/individual/util/makedepend-${finalAttrs.version}.tar.xz";
    hash = "sha256-ktDetln/9tjdvB0n/EyozrK22+Fdc/CgTtwJ8cV4LdQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Parse C sources to make dependency lists for Makefiles";
    homepage = "https://gitlab.freedesktop.org/xorg/util/makedepend";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
    ];
    mainProgram = "makedepend";
    platforms = lib.platforms.unix;
  };
})
