{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libx11 ? null,
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-A9arRNJXJGbb1xuSknTVhNNe+KGxFdtv4Qhpe9stRF8=";
  };

  vendorHash = "sha256-g2gXH0PzleT77ycLosflk7gyHL59mFtDD/6ImWtGg7o=";

  ldflags = [
    "-X main.version=${version}"
  ];

  buildInputs = lib.optionals (libx11 != null) [ libx11 ];

  meta = {
    description = "Cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = lib.licenses.mit;
    mainProgram = "lazysql";
  };
}
