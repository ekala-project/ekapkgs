{
  lib,
  fetchFromGitLab,
  fetchpatch,
  rustPlatform,
  pkg-config,
  openssl,
  installShellFiles,
  xclip ? null,
  xsel ? null,
  preferXsel ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ffsend";
  version = "0.2.77";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "ffsend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qq1nLNe4ddcsFJZaGfNQbNtqchz6tPh1kpEH/oDW3jk=";
  };

  cargoHash = "sha256-DQcuyp61r0y9fi8AV33qxN2cOrl0M8q4/VoXuV47gxQ=";

  cargoPatches = [
    (fetchpatch {
      name = "rust-1.87.0-compat.patch";
      url = "https://gitlab.com/timvisee/ffsend/-/commit/29eb167d4367929a2546c20b3f2bbf890b63c631.patch";
      hash = "sha256-BxJ+0QJP2fzQT1X3BZG1Yy9V+csIEk8xocUKSBgdG9M=";
    })
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  preBuild =
    if preferXsel && xsel != null then
      ''
        export XSEL_PATH="${xsel}/bin/xsel"
      ''
    else if xclip != null then
      ''
        export XCLIP_PATH="${xclip}/bin/xclip"
      ''
    else
      "";

  postInstall = ''
    installShellCompletion contrib/completions/ffsend.{bash,fish} --zsh contrib/completions/_ffsend
  '';

  meta = {
    description = "Easily and securely share files from the command line. A fully featured Firefox Send client";
    longDescription = ''
      Easily and securely share files and directories from the command line through a safe, private
      and encrypted link using a single simple command. Files are shared using the Send service and
      may be up to 2GB. Others are able to download these files with this tool, or through their
      web browser.
    '';
    homepage = "https://gitlab.com/timvisee/ffsend";
    license = lib.licenses.gpl3Only;
    mainProgram = "ffsend";
  };
})
