{
  lib,
  makeBinaryWrapper,
  mpv-unwrapped,
  symlinkJoin,
  yt-dlp,
  extraMakeWrapperArgs ? [ ],
  youtubeSupport ? true,
  scripts ? [ ],
}:

let
  fallbackBinPath = lib.makeBinPath (lib.optionals youtubeSupport [ yt-dlp ]);

  mostMakeWrapperArgs = lib.strings.escapeShellArgs (
    [
      "--inherit-argv0"
    ]
    ++ lib.optionals (fallbackBinPath != "") [
      "--suffix"
      "PATH"
      ":"
      fallbackBinPath
    ]
    ++ (lib.lists.flatten (
      map (
        script:
        let
          mkScriptArgs = script: scriptName: [
            "--add-flags"
            "--script=${script}/share/mpv/scripts/${scriptName}"
          ];
        in
        (mkScriptArgs script script.scriptName)
        ++ (map (extraScriptName: mkScriptArgs script extraScriptName) (script.extraScriptsToLoad or [ ]))
        ++ (script.extraWrapperArgs or [ ])
      ) scripts
    ))
    ++ extraMakeWrapperArgs
  );
in
symlinkJoin {
  pname = "mpv-with-scripts";
  inherit (mpv-unwrapped) version;

  paths = [ mpv-unwrapped.all ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    # wrapProgram can't operate on symlinks
    rm "$out/bin/mpv"
    makeWrapper "${mpv-unwrapped}/bin/mpv" "$out/bin/mpv" ${mostMakeWrapperArgs}
  '';

  meta = {
    inherit (mpv-unwrapped.meta)
      homepage
      description
      longDescription
      ;
    mainProgram = "mpv";
    license = mpv-unwrapped.meta.license or lib.licenses.gpl2Plus;
  };
}
