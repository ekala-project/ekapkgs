# Per-user PostgreSQL server
#
# Extends home.users.<name> with PostgreSQL options.
# Generates a systemd user unit that initializes the data directory on
# first start (initdb) and runs the server as the user. The server listens
# on a unix socket in $XDG_RUNTIME_DIR/postgresql and, by default, on
# localhost TCP. The database superuser is the login user, authenticated
# by peer auth over the socket.
#
# Usage:
#   home.users.alice.services.postgresql = {
#     enable = true;
#     port = 5432;
#     ensureDatabases = [ "myapp" ];
#     settings = {
#       shared_buffers = "256MB";
#       log_min_duration_statement = 250;
#     };
#   };
#
# Connect with:
#   psql -h "$XDG_RUNTIME_DIR/postgresql" myapp
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    concatMapStringsSep
    concatStringsSep
    mapAttrsToList
    escapeShellArg
    literalExpression
    replaceStrings
    versions
    ;

  # Escape a value for a systemd command line: quote it and double any `%`
  # so systemd does not treat it as a specifier.
  escapeSystemd = s: "\"${replaceStrings [ "\\" "\"" "%" ] [ "\\\\" "\\\"" "%%" ] s}\"";

  settingToString = v: if builtins.isBool v then (if v then "on" else "off") else toString v;

  postgresqlOpts =
    { config, ... }:
    let
      cfg = config.services.postgresql;

      socketDir = "%t/postgresql";

      serverSettings = {
        port = cfg.port;
        listen_addresses = cfg.listenAddresses;
      }
      // cfg.settings;

      settingsArgs = concatStringsSep " " (
        mapAttrsToList (
          name: value: "-c ${escapeSystemd "${name}=${settingToString value}"}"
        ) serverSettings
      );

      initScript = pkgs.writeShellScript "postgresql-user-init" ''
        set -eu
        if [ ! -s "$PGDATA/PG_VERSION" ]; then
          echo "Initializing PostgreSQL data directory at $PGDATA"
          mkdir -p "$PGDATA"
          chmod 700 "$PGDATA"
          ${cfg.package}/bin/initdb -D "$PGDATA" ${concatMapStringsSep " " escapeShellArg cfg.initdbArgs}
        fi
      '';

      ensureScript = pkgs.writeShellScript "postgresql-user-ensure" ''
        set -eu
        socket="$1"
        for db in ${concatMapStringsSep " " escapeShellArg cfg.ensureDatabases}; do
          # psql only interpolates :'db' in queries read from stdin, not -c.
          exists=$(${cfg.package}/bin/psql -h "$socket" -p ${toString cfg.port} -d postgres -tAX \
            -v ON_ERROR_STOP=1 -v db="$db" <<< "SELECT 1 FROM pg_database WHERE datname = :'db'")
          if [ "$exists" != "1" ]; then
            echo "Creating database $db"
            ${cfg.package}/bin/createdb -h "$socket" -p ${toString cfg.port} "$db"
          fi
        done
      '';
    in
    {
      options.services.postgresql = {
        enable = mkEnableOption "PostgreSQL user service";

        package = mkOption {
          type = types.package;
          default = pkgs.postgresql;
          defaultText = literalExpression "pkgs.postgresql";
          description = "The PostgreSQL package to use.";
        };

        dataDir = mkOption {
          type = types.str;
          default = "%h/.local/share/postgresql/${versions.major cfg.package.version}";
          defaultText = literalExpression ''"%h/.local/share/postgresql/''${lib.versions.major package.version}"'';
          description = ''
            Directory holding the PostgreSQL cluster. systemd specifiers
            such as `%h` (home directory) are expanded. The default is
            versioned by major release, so upgrading the package starts a
            fresh cluster rather than failing on an incompatible one.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 5432;
          description = "TCP port, also used in the unix socket file name.";
        };

        listenAddresses = mkOption {
          type = types.str;
          default = "localhost";
          example = "";
          description = ''
            Comma-separated TCP addresses to listen on. Set to the empty
            string to only listen on the unix socket.
          '';
        };

        initdbArgs = mkOption {
          type = types.listOf types.str;
          default = [
            "--auth-local=peer"
            "--auth-host=scram-sha-256"
          ];
          description = "Extra arguments passed to initdb when creating the cluster.";
        };

        settings = mkOption {
          type = types.attrsOf (
            types.oneOf [
              types.str
              types.int
              types.float
              types.bool
            ]
          );
          default = { };
          example = literalExpression ''
            {
              shared_buffers = "256MB";
              log_statement = "all";
            }
          '';
          description = ''
            Server settings passed as `-c name=value` flags. These take
            precedence over postgresql.conf in the data directory.
          '';
        };

        ensureDatabases = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "myapp" ];
          description = ''
            Databases created after the server starts if they do not
            already exist. They are owned by the login user.
          '';
        };
      };

      config = mkIf cfg.enable {
        packages = [ cfg.package ];

        file.".config/systemd/user/postgresql.service".text = ''
          [Unit]
          Description=PostgreSQL database server (user)
          Documentation=man:postgres(1)

          [Service]
          Type=notify
          Environment=PGDATA=${cfg.dataDir}
          RuntimeDirectory=postgresql
          ExecStartPre=${initScript}
          ExecStart=${cfg.package}/bin/postgres -D ''${PGDATA} -k ${socketDir} ${settingsArgs}
          ${lib.optionalString (cfg.ensureDatabases != [ ]) "ExecStartPost=${ensureScript} ${socketDir}"}
          ExecReload=/bin/kill -HUP $MAINPID
          KillMode=mixed
          KillSignal=SIGINT
          TimeoutSec=120
          Restart=on-failure

          [Install]
          WantedBy=default.target
        '';
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule postgresqlOpts);
  };
}
