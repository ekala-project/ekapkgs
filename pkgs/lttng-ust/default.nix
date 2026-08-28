{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  asciidoc,
  xmlto,
  liburcu,
  numactl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lttng-ust";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "lttng";
    repo = "lttng-ust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9WZDjOGfflEc6BUUO3W70KeLcZnTaePkF8eg8Ns/lQc=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    asciidoc
    xmlto
  ];

  propagatedBuildInputs = [ liburcu ];

  buildInputs = [
    numactl
    python3
  ];

  postPatch = ''
    substituteInPlace doc/man/Makefile.am \
      --replace-fail '$(XMLTO)' '$(XMLTO) --skip-validation'
  '';

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [ "--disable-examples" ];

  doCheck = true;

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    description = "LTTng Userspace Tracer libraries";
    mainProgram = "lttng-gen-tp";
    homepage = "https://lttng.org/";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
      mit
    ];
    platforms = lib.intersectLists lib.platforms.linux liburcu.meta.platforms;
  };
})
