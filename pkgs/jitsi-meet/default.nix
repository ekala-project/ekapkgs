{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  libarchive,
  nodejs,
}:

let
  version = "1.0.9365";
in
buildNpmPackage {
  pname = "jitsi-meet";
  inherit version;

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jitsi-meet";
    tag = lib.last (lib.splitVersion version);
    hash = "sha256-gAXY40jvQjGhitbpWjJ+C8GZwuRu/zyJw2NN5yf/l6o=";
  };

  npmDepsHash = "sha256-5fGaX8VFCCMkTeQuhFPwd9W7cBNVML/bVYLODq07s5w=";

  makeCacheWritable = true;

  env.forceGitDeps = true;

  nativeBuildInputs = [
    libarchive
  ];

  buildPhase = ''
    runHook preBuild
    make source-package
    runHook postBuild
  '';

  # yes, the only way in the build system is to generate a tarball and extract
  # it immediately after
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    bsdtar -xf jitsi-meet.tar.bz2 -C $out --strip-components 1
    runHook postInstall
  '';

  dontNpmInstall = true;

  meta = {
    description = "Secure, Simple and Scalable Video Conferences";
    longDescription = ''
      Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge
      to provide high quality, secure and scalable video conferences.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet";
    license = lib.licenses.asl20;
    inherit (nodejs.meta) platforms;
  };
}
