{ config, pkgs, ... }:

{
  # Full prometheus server not yet available in EkaOS
  # services.prometheus.enable = true;

  services.prometheus-node-exporter = {
    enable = true;
  };
}
