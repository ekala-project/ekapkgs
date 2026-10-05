{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "d2";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = "d2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HhCktLU43Y/uje038axwO7tNqO353mV/JID223sBtd8=";
  };

  vendorHash = "sha256-LRvQ4diXmoZNnRomVv6HTni6jrJ8e0IHqxVmJhEFR/w=";

  excludedPackages = [ "./e2etests" ];

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  doCheck = false;

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  meta = {
    description = "Modern diagram scripting language that turns text to diagrams";
    mainProgram = "d2";
    homepage = "https://d2lang.com";
    license = lib.licenses.mpl20;
  };
})
