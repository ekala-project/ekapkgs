{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "livekit";
  version = "1.13.5";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TfQDYChRtowFzkVhuQrLfKeKrcSWLPY9R/D6to4mRSI=";
  };

  vendorHash = "sha256-Mn+6+lDtSZPp3xrf1OzsBdecuXnwaKwGDXtcYXb5S7Y=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/livekit-server
  '';
  meta = {
    description = "End-to-end stack for WebRTC. SFU media server and SDKs";
    homepage = "https://livekit.io/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "livekit-server";
  };
})
