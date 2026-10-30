{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "easy-rsa";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "easy-rsa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gNuVijMAHVKEHU0Z6INKUZt68qSg5ssxSaXOH/+MU1I=";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    runHook preInstall
    install -Dm755 easyrsa3/easyrsa $out/bin/easyrsa
    install -Dm644 easyrsa3/openssl-easyrsa.cnf $out/share/easy-rsa/openssl-easyrsa.cnf
    install -Dm644 easyrsa3/vars.example $out/share/easy-rsa/vars.example
    cp -r easyrsa3/x509-types $out/share/easy-rsa/x509-types
    runHook postInstall
  '';

  meta = {
    description = "Simple shell-based CA utility";
    homepage = "https://github.com/OpenVPN/easy-rsa";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "easyrsa";
  };
})
