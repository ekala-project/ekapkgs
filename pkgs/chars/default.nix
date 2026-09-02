{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chars";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "boinkor-net";
    repo = "chars";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mBtwdPzIc6RgEFTyReStFlhS4UhhRWjBTKT6gD3tzpQ=";
  };

  cargoHash = "sha256-Df+twOjzfq+Vxzuv+APiy94XmhBajgk+6+1BRFf+xm0=";

  meta = {
    description = "Commandline tool to display information about unicode characters";
    mainProgram = "chars";
    homepage = "https://github.com/boinkor-net/chars";
    license = lib.licenses.mit;
  };
})
