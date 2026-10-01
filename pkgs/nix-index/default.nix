{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,
  nix,
  makeShellWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-index";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yl/acohrgP0C5w4eozNcWcpCGhmMMjFbzgHsKwXKw00=";
  };

  cargoHash = "sha256-EJbNptLskphe+xfI8oQ0DVUx6y4dO52eeuPiG6FSQbI=";

  nativeBuildInputs = [
    pkg-config
    makeShellWrapper
  ];

  buildInputs = [
    openssl
    curl
    sqlite
  ];

  postInstall = ''
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
    wrapProgram $out/bin/nix-index \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
    wrapProgram $out/bin/nix-locate \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = {
    description = "Files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    license = lib.licenses.bsd3;
    mainProgram = "nix-index";
  };
})
