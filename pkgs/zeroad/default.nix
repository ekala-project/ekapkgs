{
  lib,
  buildEnv,
  makeWrapper,
  zeroad-unwrapped ? null,
  zeroad-data ? null,
}:

assert
  zeroad-unwrapped != null && zeroad-data != null -> zeroad-unwrapped.version == zeroad-data.version;

buildEnv {
  name = "zeroad-${if zeroad-unwrapped != null then zeroad-unwrapped.version else "0"}";

  nativeBuildInputs = [ makeWrapper ];

  paths =
    lib.optional (zeroad-unwrapped != null) zeroad-unwrapped
    ++ lib.optional (zeroad-data != null) zeroad-data;

  pathsToLink = [
    "/"
    "/bin"
  ];

  postBuild = ''
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --set ZEROAD_ROOTDIR "$out/share/0ad"
    done
  '';

  meta = (if zeroad-unwrapped != null then zeroad-unwrapped.meta else { }) // {
    hydraPlatforms = [ ];
  };
}
