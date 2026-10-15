{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  comet-gog_kind ? "latest",
}:

let
  versionInfoTable = {
    "latest" = {
      version = "0.3.2";
      srcHash = "sha256-DUkeOkUf9roZGKqdjoy/DfUL1OrVfSVjMhEvfACLEoo=";
      cargoHash = "sha256-AiBoM7rywsuokz/fmLmye630N+t1GtwZsxkmtlH5MI8=";
    };
    "heroic" = {
      version = "0.2.0";
      srcHash = "sha256-LAEt2i/SRABrz+y2CTMudrugifLgHNxkMSdC8PXYF0E=";
      cargoHash = "sha256-SvDE+QqaSK0+4XgB3bdmqOtwxBDTlf7yckTR8XjmMXc=";
    };
  };

  versionInfo = versionInfoTable.${comet-gog_kind};
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comet-gog";
  inherit (versionInfo) version cargoHash;

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    tag = "v${finalAttrs.version}";
    hash = versionInfo.srcHash;
    fetchSubmodules = true;
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  meta = {
    changelog = "https://github.com/imLinguin/comet/releases/tag/${finalAttrs.src.tag}";
    description = "Open Source implementation of GOG Galaxy's Communication Service";
    homepage = "https://github.com/imLinguin/comet";
    license = lib.licenses.gpl3Plus;
    mainProgram = "comet";
  };
})
