{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule rec {
  pname = "docker-credential-helpers";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker-credential-helpers";
    rev = "v${version}";
    sha256 = "sha256-qrcAMuQxAZE+F5xyTbaUFo4qVDqV/WMS9cO+Vsn7zU8=";
  };

  vendorHash = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsecret ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/docker/docker-credential-helpers/credentials.Version=${version}"
  ];

  buildPhase = ''
    for cmd in secretservice pass; do
      go build -ldflags "${toString ldflags}" -trimpath -o bin/docker-credential-$cmd ./$cmd/cmd
    done
  '';

  installPhase = ''
    install -Dm755 -t $out/bin bin/docker-credential-*
  '';

  meta = {
    description = "Suite of programs to use native stores to keep Docker credentials safe";
    homepage = "https://github.com/docker/docker-credential-helpers";
    license = lib.licenses.mit;
  };
}
