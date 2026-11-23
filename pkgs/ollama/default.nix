{
  lib,
  buildGoModule,
  fetchFromGitHub,
  cmake,
  gcc,
  stdenv,
}:

buildGoModule rec {
  pname = "ollama";
  version = "0.40.17";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${version}";
    hash = "sha256-PyZVSRttWuHG8zrEuKo3Q1r6O1SI8whj1IJV32cHmcU=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-z3P8LkArvwCZhvi4TERMBL7nyWWaDPsaDzpXQr9MwJ0=";

  # Ollama has complex build with CGo and llama.cpp
  # For simplicity, this builds the basic CPU-only version

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ollama/ollama/version.Version=${version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Get up and running with large language models locally";
    homepage = "https://ollama.com";
    license = lib.licenses.mit;
    mainProgram = "ollama";
    platforms = lib.platforms.unix;
  };
}
