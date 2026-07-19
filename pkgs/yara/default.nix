{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  jansson,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yara";
  version = "4.5.5";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a+oLxVJgdDrnOra85PPo8ZlFhinawWHuRtVE39S8yJk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    file
    jansson
  ];

  preConfigure = "./bootstrap.sh";

  configureFlags = [
    "--with-crypto"
    "--enable-cuckoo"
    "--enable-dex"
    "--enable-dotnet"
    "--enable-macho"
    "--enable-magic"
  ];

  # bin/yara contain forbidden references to /build/.
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/bin/yara
  '';

  meta = {
    description = "Tool to perform pattern matching for malware-related tasks";
    homepage = "http://Virustotal.github.io/yara/";
    license = lib.licenses.bsd3;
    mainProgram = "yara";
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
