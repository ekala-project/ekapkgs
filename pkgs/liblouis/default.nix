{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  python3,
  texinfo,
  help2man,
  libyaml,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblouis";
  version = "3.38.0";

  outputs = [
    "out"
    "dev"
    "info"
  ]
  ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "man" ];

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OmYMldo2id2HKAM0Hxi6r86khSUnzu22CkJhGBhaaL8=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    python3
    python3.pkgs.build
    python3.pkgs.installer
    python3.pkgs.setuptools
    python3.pkgs.wheel
    texinfo
    help2man
  ];

  buildInputs = [
    libyaml
  ];

  nativeCheckInputs = [
    perl
  ];

  configureFlags = [
    "--enable-ucs4"
  ];

  postPatch = ''
    patchShebangs tests
    substituteInPlace python/louis/__init__.py.in --replace "###LIBLOUIS_SONAME###" "$out/lib/liblouis.so"
  '';

  postInstall = ''
    pushd python
    python -m build --no-isolation --outdir dist/ --wheel
    python -m installer --prefix $out dist/*.whl
    popd
  '';

  doCheck = true;

  meta = {
    description = "Open-source braille translator and back-translator";
    homepage = "https://liblouis.io/";
    license = with lib.licenses; [
      lgpl21Plus
      gpl3Plus
    ];
    platforms = lib.platforms.unix;
  };
})
