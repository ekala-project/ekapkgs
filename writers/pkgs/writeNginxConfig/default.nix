{
  gixy,
  runCommandLocal,
}:

let
  awkFormatNginx = builtins.toFile "awkFormat-nginx.awk" ''
    awk -f
    {sub(/^[ \t]+/,"");idx=0}
    /\{/{ctx++;idx=1}
    /\}/{ctx--}
    {id="";for(i=idx;i<ctx;i++)id=sprintf("%s%s", id, "\t");printf "%s%s\n", id, $0}
  '';
in
name: text:
runCommandLocal name
  {
    inherit text;
    nativeBuildInputs = [ gixy ];
  } # sh
  ''
    # nginx-config-formatter has an error - https://github.com/1connect/nginx-config-formatter/issues/16
    printf '%s' "$text" | awk -f ${awkFormatNginx} | sed '/^\s*$/d' > $out
    gixy $out || (echo "\n\nThis can be caused by combining multiple incompatible services on the same hostname.\n\nFull merged config:\n\n"; cat $out; exit 1)
  ''
