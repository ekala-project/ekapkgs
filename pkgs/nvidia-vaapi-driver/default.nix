{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  libdrm,
  libGL,
  gstreamer,
  nv-codec-headers,
  libva,
  addDriverRunpath,
}:

stdenv.mkDerivation rec {
  pname = "nvidia-vaapi-driver";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "elFarto";
    repo = "nvidia-vaapi-driver";
    rev = "v${version}";
    sha256 = "sha256-eJ523lEmB4s+R/QN4J8t6LZ4zw2rEQsaaRBJdjH8Amo=";
  };

  patches = [
    ./0001-hardcode-install_dir.patch
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    addDriverRunpath
  ];

  buildInputs = [
    libdrm
    libGL
    gstreamer.gstreamer
    # TODO(ekapkgs): re-enable gst-plugins-bad when pulseaudio/webrtc-audio-processing builds
    nv-codec-headers
    libva
  ];

  postFixup = ''
    addDriverRunpath "$out/lib/dri/nvidia_drv_video.so"
  '';

  meta = {
    homepage = "https://github.com/elFarto/nvidia-vaapi-driver";
    description = "VA-API implementation using NVIDIA's NVDEC";
    changelog = "https://github.com/elFarto/nvidia-vaapi-driver/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}
