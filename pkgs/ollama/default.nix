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
  version = "0.35.1";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-5qJyJhqL/Zhfq2s/Z3x5Sq0GFgBai812cQkgNq82nm4=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-NJjr949bcFvJvdcMDp6DmIa/QkpjfBXZNwPOtTZH09c=";

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
