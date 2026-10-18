{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  buildMozillaMach,
  wrapFirefox,
}:

let
  firefox-unwrapped = buildMozillaMach {
    pname = "firefox";
    version = "157.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/157.0.1/source/firefox-157.0.1.source.tar.xz";
      sha512 = "c019202b2f87d25b3605bbf7266f3bb4d59745e48536f297d3f00cc3524a1cd2eba416a5a3cd0ecee6b0762d0f35bf3c5fcce286ebc7bc741263bebd0f102858";
    };

    meta = {
      changelog = "https://www.firefox.com/en-US/firefox/157.0.1/releasenotes/";
      description = "Web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      platforms = lib.platforms.unix;
      broken = stdenv.buildPlatform.is32bit;
      maxSilent = 14400;
      license = lib.licenses.mpl20;
      mainProgram = "firefox";
    };
  };
in
wrapFirefox firefox-unwrapped { }
