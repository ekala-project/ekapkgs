# Playwright's chromium browser set (FODs from cdn.playwright.dev), not a
# source-built Chromium or ffmpeg. The inner chrome / headless-shell / ffmpeg
# zips are Playwright-revision-pinned blobs for PLAYWRIGHT_BROWSERS_PATH;
# they are not pkgs.chromium / pkgs.ffmpeg.
#
# Chromium-only: firefox-bin is missing from this set and webkit's closure
# is huge. Consumers that only launch chromium (typical Node e2e) use
# passthru.browsers.
{
  lib,
  callPackage,
  linkFarm,
  runCommand,
  makeFontsConf,
  stdenv,
}:
let
  version = "1.61.1";
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  browsersJSON = (lib.importJSON ./browsers.json).browsers;
  fontconfig_file = makeFontsConf { fontDirectories = [ ]; };

  components = {
    chromium = callPackage ./chromium.nix {
      inherit system throwSystem fontconfig_file;
      inherit (browsersJSON.chromium) revision browserVersion;
    };
    chromium-headless-shell = callPackage ./chromium-headless-shell.nix {
      inherit system throwSystem;
      inherit (browsersJSON."chromium-headless-shell") revision browserVersion;
    };
    ffmpeg = callPackage ./ffmpeg.nix {
      inherit system throwSystem;
      inherit (browsersJSON.ffmpeg) revision;
    };
  };

  browsers = linkFarm "playwright-browsers" (
    lib.listToAttrs (
      map
        (name:
          lib.nameValuePair
            "${lib.replaceStrings [ "-" ] [ "_" ] name}-${browsersJSON.${name}.revision}"
            components.${name})
        [ "chromium" "chromium-headless-shell" "ffmpeg" ]
    )
  );
in
runCommand "playwright-driver"
{
  passthru = {
    inherit browsers version;
  };
  meta = {
    description = "Playwright ${version} chromium browsers";
    homepage = "https://playwright.dev";
    # Chrome for Testing is Google Chrome.
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
} "mkdir -p $out"
