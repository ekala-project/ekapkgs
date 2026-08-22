{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "keyd";
  version = "2.6.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l7yjGpicX1ly4UwF7gcOTaaHPRnxVUMwZkH70NDLL5M=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/local ""

    substituteInPlace keyd.service.in \
      --replace-fail @PREFIX@ $out
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  enableParallelBuilding = true;

  postInstall = ''
    rm -rf $out/etc
  '';

  meta = {
    description = "Key remapping daemon for Linux";
    homepage = "https://github.com/rvaiya/keyd";
    changelog = "https://github.com/rvaiya/keyd/blob/master/docs/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "keyd";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
