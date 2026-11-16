{ name
, revision
, browserVersion ? ""
,
}:
let
  cftUrl =
    path:
      assert browserVersion != "";
      "https://cdn.playwright.dev/builds/cft/${browserVersion}/${path}";

  registryUrl =
    browser: archive:
    "https://cdn.playwright.dev/dbazure/download/playwright/builds/${browser}/${revision}/${archive}";

  mk = url: stripRoot: hash: {
    inherit
      url
      stripRoot
      hash
      ;
  };
in
{
  chromium = {
    x86_64-linux = mk (cftUrl "linux64/chrome-linux64.zip") true "sha256-/0OwT0Asm4A/rUkFruw1JYWbDInFJPuDX0CEdNjeMLo=";
    aarch64-linux = mk (registryUrl "chromium" "chromium-linux-arm64.zip") true "sha256-5vNF1/utXGctixYJj/0qvi6X0qklIG9XCcet94feQoA=";
    aarch64-darwin = mk (cftUrl "mac-arm64/chrome-mac-arm64.zip") false "sha256-aJbvZQ1hY0FfDC+ZktfW2yNW3nwc0kh/P30+n/cmLf0=";
  };

  "chromium-headless-shell" = {
    x86_64-linux = mk (cftUrl "linux64/chrome-headless-shell-linux64.zip") false "sha256-wnN0SL8QqiFGZdevm06WOhR9o6q34+kHL5ay1mRYnxs=";
    aarch64-linux = mk (registryUrl "chromium" "chromium-headless-shell-linux-arm64.zip") false "sha256-d9Qr3q4GjtUp2ZVFSq+M2Ap++WKaEscRzEkk4JwXL/E=";
    aarch64-darwin = mk (cftUrl "mac-arm64/chrome-headless-shell-mac-arm64.zip") false "sha256-qWrMOreqTOFhmFBROlXIPXrM3wqNT7iJJwpelVFke6I=";
  };

  ffmpeg = {
    x86_64-linux = mk (registryUrl "ffmpeg" "ffmpeg-linux.zip") false "sha256-AWTiui+ccKHxsIaQSgc5gWCJT5gYwIWzAEqSuKgVqZU=";
    aarch64-linux = mk (registryUrl "ffmpeg" "ffmpeg-linux-arm64.zip") false "sha256-1mOKO2lcnlwLsC6ob//xKnKrCOp94pw8X14uBxCdj0Q=";
    aarch64-darwin = mk (registryUrl "ffmpeg" "ffmpeg-mac-arm64.zip") false "sha256-ky10UQj+XPVGpaWAPvKd51C5brml0y9xQ6iKcrxAMRc=";
  };
}.${name}
