{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "proxify";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2ZPccvNvdbgbUuAnR/sdECvtuU5LV6lBKfXEbfk27EM=";
  };

  vendorHash = "sha256-Ln73YcRyAqN/aKMGu6VREhZfVeKN0LkFsdK6Bs3FNbU=";

  meta = {
    description = "Proxy tool for HTTP/HTTPS traffic capture";
    longDescription = ''
      This tool supports multiple operations such as request/response dump, filtering
      and manipulation via DSL language, upstream HTTP/Socks5 proxy. Additionally a
      replay utility allows to import the dumped traffic (request/responses with correct
      domain name) into other tools by simply setting the upstream proxy to proxify.
    '';
    homepage = "https://github.com/projectdiscovery/proxify";
    changelog = "https://github.com/projectdiscovery/proxify/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
