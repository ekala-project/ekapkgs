{
  stdenv,
  lib,
  fetchurl,
  fetchzip,
  autoreconfHook,
  fetchpatch,
  modelUrl ? "",
  modelHash ? "",
}:

let
  modelVersionJSON = lib.importJSON ./model-version.json;

  default_model_version = modelVersionJSON.version;

  model_url =
    if (modelUrl == "") then
      "https://media.xiph.org/rnnoise/models/rnnoise_data-${default_model_version}.tar.gz"
    else
      modelUrl;
  model_hash = if (modelHash == "") then modelVersionJSON.hash else modelHash;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "rnnoise";
  version = "0.2";

  src = fetchzip {
    urls = [
      "https://gitlab.xiph.org/xiph/rnnoise/-/archive/v${finalAttrs.version}/rnnoise-v${finalAttrs.version}.tar.gz"
      "https://github.com/xiph/rnnoise/archive/v${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-Qaf+0iOprq7ILRWNRkBjsniByctRa/lFVqiU5ZInF/Q=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/xiph/rnnoise/commit/372f7b4b76cde4ca1ec4605353dd17898a99de38.patch";
      hash = "sha256-Dzikb59hjVxd1XIEj/Je4evxtGORkaNcqE+zxOJMSvs=";
    })
  ];

  model = fetchurl {
    url = model_url;
    hash = model_hash;
  };

  postPatch = ''
    tar xvomf ${finalAttrs.model}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -Dt $out/bin examples/.libs/rnnoise_demo
  '';

  meta = {
    description = "Recurrent neural network for audio noise reduction";
    homepage = "https://people.xiph.org/~jm/demo/rnnoise/";
    license = lib.licenses.bsd3;
    mainProgram = "rnnoise_demo";
    platforms = lib.platforms.all;
  };
})
