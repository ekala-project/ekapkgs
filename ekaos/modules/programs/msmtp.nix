# System-wide msmtp SMTP client configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.msmtp;

  mkValueString =
    v:
    if v == true then
      "on"
    else if v == false then
      "off"
    else
      generators.mkValueStringDefault { } v;

  mkKeyValueString = k: v: "${k} ${mkValueString v}";

  mkInnerSectionString = attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValueString attrs);

  mkAccountString = name: attrs: ''
    account ${name}
    ${mkInnerSectionString attrs}
  '';
in

{
  options.programs.msmtp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install and configure msmtp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.msmtp;
      description = "msmtp package to use.";
    };

    defaults = mkOption {
      type = types.attrs;
      default = { };
      example = {
        port = 587;
        tls = true;
      };
      description = ''
        Default values applied to all accounts.
        See msmtp(1) for the available options.
      '';
    };

    accounts = mkOption {
      type = types.attrsOf types.attrs;
      default = { };
      example = {
        "default" = {
          host = "smtp.example";
          auth = true;
          user = "someone";
          passwordeval = "cat /secrets/password.txt";
        };
      };
      description = ''
        Named accounts and their respective configurations.
        The special name "default" allows a default account to be defined.
        See msmtp(1) for the available options.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra lines to add to the msmtp configuration verbatim.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."msmtprc".text = ''
      defaults
      ${mkInnerSectionString cfg.defaults}

      ${concatStringsSep "\n" (mapAttrsToList mkAccountString cfg.accounts)}

      ${cfg.extraConfig}
    '';
  };
}
