{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "oh-my-posh";
  version = "33.3.1";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "oh-my-posh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Dbb2eaXZVIseWZPm1UT6AjkEPa88Buo2v0vnAKyjSU=";
  };

  vendorHash = "sha256-Oq5S3zlhryG22dM03ymEtammorrdg+TGNcml2/21OEY=";

  sourceRoot = "${finalAttrs.src.name}/src";

  ldflags = [
    "-s"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Version=${finalAttrs.version}"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Date=1970-01-01T00:00:00Z"
  ];

  tags = [
    "netgo"
    "osusergo"
    "static_build"
  ];

  postPatch = ''
    # these tests requires internet access
    rm config/migrate_glyphs_test.go cli/upgrade/notice_test.go segments/upgrade_test.go
  '';

  postInstall = ''
    mv $out/bin/{src,oh-my-posh}
    mkdir -p $out/share/oh-my-posh
    cp -r $src/themes $out/share/oh-my-posh/
  '';

  meta = {
    description = "Prompt theme engine for any shell";
    mainProgram = "oh-my-posh";
    homepage = "https://ohmyposh.dev";
    changelog = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
