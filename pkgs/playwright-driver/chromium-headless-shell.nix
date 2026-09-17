{ fetchzip
, revision
, browserVersion
, system
, throwSystem
, stdenv
, autoPatchelfHook
, patchelf
, alsa-lib
, at-spi2-atk
, expat
, glib
, libxcomposite
, libxdamage
, libxfixes
, libxrandr
, libgbm
, libgcc
, libxkbcommon
, nspr
, nss
, ...
}:
let
  download =
    (import ./browser-downloads.nix {
      name = "chromium-headless-shell";
      inherit revision browserVersion;
    }).${system} or throwSystem;

  linux = stdenv.mkDerivation {
    name = "playwright-chromium-headless-shell";
    src = fetchzip {
      inherit (download) url stripRoot hash;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      patchelf
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      expat
      glib
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
      libgbm
      libgcc
      libxkbcommon
      nspr
      nss
    ];

    buildPhase = ''
      cp -R . $out
    '';
  };

  darwin = fetchzip {
    inherit (download) url stripRoot hash;
  };
in
  {
    x86_64-linux = linux;
    aarch64-linux = linux;
    aarch64-darwin = darwin;
  }.${system} or throwSystem
