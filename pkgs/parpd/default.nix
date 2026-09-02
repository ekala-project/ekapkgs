{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parpd";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "NetworkConfiguration";
    repo = "parpd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6qmoAW9jm7xMRHZUMQLpe0N+UeVnQP8dC4+Iq+d5Eaw=";
  };
  meta = {
    homepage = "https://roy.marples.name/projects/parpd";
    changelog = "https://github.com/NetworkConfiguration/parpd/releases/tag/v${finalAttrs.version}";
    description = "Proxy ARP Daemon that complies with RFC 1027";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    mainProgram = "parpd";
  };
})
