{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  guile,
  libssh,
  autoreconfHook,
  pkg-config,
  texinfo,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-ssh";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = "guile-ssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gaCFQxn69KENqdET/331Bnznl9uNwgUO2xuIE4Zpxgo=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/artyom-poptsov/guile-ssh/pull/31/commits/38636c978f257d5228cd065837becabf5da16854.patch";
      hash = "sha256-J+TDgdjihKoEjhbeH+BzqrHhjpVlGdscRj3L/GAFgKg=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
    which
  ];

  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
    libssh
  ];

  enableParallelBuilding = true;

  # FAIL: server-client.scm
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    mv $out/bin/*.scm $out/share/guile-ssh
    rmdir $out/bin
  '';

  meta = {
    description = "Bindings to Libssh for GNU Guile";
    homepage = "https://github.com/artyom-poptsov/guile-ssh";
    license = lib.licenses.gpl3Plus;
    platforms = guile.meta.platforms;
  };
})
