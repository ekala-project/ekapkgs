{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "irtt";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "heistp";
    repo = "irtt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-22ibxq78pt9pHq58jowMo0nENFy39ZSl/oBw9/F7vAc=";
  };

  vendorHash = "sha256-du6PXKBrb3qrvD6rBFWfY3pK2gVu7/nvvom5mHs+JJs=";
  versionCheckProgramArg = "version";

  meta = {
    description = "Measures round-trip time, one-way delay and other metrics using UDP";
    homepage = "https://github.com/heistp/irtt";
    license = lib.licenses.gpl2Only;
    mainProgram = "irtt";
    platforms = lib.platforms.linux;
  };
})
