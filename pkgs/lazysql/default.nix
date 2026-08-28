{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  libx11 ? null,
}:

buildGo126Module rec {
  pname = "lazysql";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-PWmLJ7Sjt68aYqjGhkQ2ZMU7O2Qer2ECocBQPWL8rNk=";
  };

  vendorHash = "sha256-FbAt/HsjoxqAKWQqqWN2xuyyTG2Ic4DcyEU4O0rjpQE=";

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
