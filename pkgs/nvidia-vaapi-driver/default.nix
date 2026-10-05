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
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "elFarto";
    repo = "nvidia-vaapi-driver";
    rev = "v${version}";
    sha256 = "sha256-cEEPRKoWtNXk8LsDbkhNjnIY7UD1rfYbv2Q6ThG0YLg=";
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
    gstreamer
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
