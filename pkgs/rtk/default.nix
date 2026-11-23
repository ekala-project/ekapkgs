{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  jq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtk";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sfx7rfoiXgnaqW0Gq5fiQqKY2NsSO7rwmxWxqTgkzbQ=";
  };

  cargoHash = "sha256-X1TkZyG/aYEhUeQmpxEG/rXi1iUCFkxSNc7iD1ZGCy8=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/libexec/rtk
    cp -r $src/hooks $out/libexec/rtk/hooks
    chmod -R +w $out/libexec/rtk/hooks
    find $out/libexec/rtk/hooks -name '*.sh' -exec chmod 755 {} \;
    for f in $(find $out/libexec/rtk/hooks -name '*.sh'); do
      wrapProgram "$f" \
        --prefix PATH : ${lib.makeBinPath [ jq ]}:$out/bin
    done
  '';

  meta = {
    description = "CLI proxy that reduces LLM token consumption by 60-90% on common dev commands";
    homepage = "https://github.com/rtk-ai/rtk";
    changelog = "https://github.com/rtk-ai/rtk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "rtk";
    platforms = lib.platforms.unix;
  };
})
