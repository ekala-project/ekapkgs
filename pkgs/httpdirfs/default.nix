{
  curl,
  expat,
  fetchFromGitHub,
  fuse3,
  gumbo,
  help2man,
  lib,
  libuuid,
  meson,
  ninja,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httpdirfs";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = "httpdirfs";
    tag = finalAttrs.version;
    hash = "sha256-HMcb23Rk7MD4qsdXXFaOqOenb87BDB1N1ov4wWPOq58=";
  };

  nativeBuildInputs = [
    meson.configurePhaseHook
    help2man
    meson
    ninja
    pkg-config
  ];

  postPatch = ''
    sed -i "/subdir('tests')/d" meson.build
  '';

  buildInputs = [
    curl
    expat
    fuse3
    gumbo
    libuuid
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=attribute-warning"
    "-Wno-error=pedantic"
  ];

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe finalAttrs.finalPackage} --version";
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    changelog = "https://github.com/fangfufu/httpdirfs/releases/tag/${finalAttrs.version}";
    description = "FUSE filesystem for HTTP directory listings";
    homepage = "https://github.com/fangfufu/httpdirfs";
    license = lib.licenses.gpl3Only;
    mainProgram = "httpdirfs";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
