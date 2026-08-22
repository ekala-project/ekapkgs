{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  makeWrapper,
  olm,
}:

buildGo126Module rec {
  pname = "gomuks";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "gomuks";
    repo = "gomuks";
    rev = "v${version}";
    sha256 = "sha256-bDJXo8d9K5UO599HDaABpfwc9/dJJy+9d24KMVZHyvI=";
  };

  vendorHash = "sha256-0my58bVKLWbdTwhAnXMruNjujd07NXFn4bkRe1cUYpE=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ olm ];

  meta = {
    homepage = "https://maunium.net/go/gomuks/";
    description = "Terminal based Matrix client written in Go";
    mainProgram = "gomuks";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
  };
}
