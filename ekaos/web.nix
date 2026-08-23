{ config, ... }:

{
  security.acme.acceptTerms = true;
  security.acme.email = "jonringer117@gmail.com";
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;
      add_header 'Referrer-Policy' 'origin-when-cross-origin';
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type-Options nosniff;
      add_header X-XSS-Protection "1; mode=block";
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    virtualHosts = {
      "jonringer.us" = {
        forceSSL = true;
        enableACME = true;

        serverAliases = [ "www.jonringer.us" ];
        root = "/var/www/jonringer";
        # locations."/".index = "index.html";  # TODO: check if location index works
      };

      "hydra.jonringer.us" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.hydra.port}";
          # proxyWebsockets not available in EkaOS nginx module
        };
      };

      "cache.jonringer.us" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://[::1]:9000";
        };
      };
    };
  };
}
