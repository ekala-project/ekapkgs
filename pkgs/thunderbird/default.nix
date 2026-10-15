{
  lib,
  stdenv,
  buildMozillaMach,
  fetchurl,
  wrapFirefox,
}:

let
  thunderbird-unwrapped = (buildMozillaMach {
    pname = "thunderbird";
    version = "157.0.1";
    application = "comm/mail";
    applicationName = "Thunderbird";
    binaryName = "thunderbird";
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/157.0.1/source/thunderbird-157.0.1.source.tar.xz";
      sha512 = "12c6151150cadce68b113720788ff6d4cdcd39ae57131152f92a272a76c2590fd929edd45faed4e81e1f32eb58d0b22ca003a37294b9daf6648d39194f09fd95";
    };

    meta = {
      changelog = "https://www.thunderbird.net/en-US/thunderbird/157.0.1/releasenotes/";
      description = "Full-featured e-mail client";
      homepage = "https://www.thunderbird.net/";
      mainProgram = "thunderbird";
      platforms = lib.platforms.unix;
      broken = stdenv.buildPlatform.is32bit;
      license = lib.licenses.mpl20;
    };
  }).override {
    enableLocation = false;
    enableWebRTC = false;
    enablePGO = false;
    enableCrashReporter = false;
  };
in
wrapFirefox thunderbird-unwrapped { }
