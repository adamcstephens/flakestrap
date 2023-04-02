{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.flakestrap;
in {
  options = {
    flakestrap = {
      enable = lib.mkEnableOption "flakestrap";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.callPackage ./package.nix {};
        defaultText = "pkgs.flakestrap";
        description = "The flakestrap package to use.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.flakestrap = {
      description = "flakestrap";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Environment = ["PATH=/run/current-system/sw/bin:${lib.makeBinPath [pkgs.git]}"];
        Type = "oneshot";
        ExecStart = "${cfg.package}/bin/flakestrap";
      };
      unitConfig = {
        Wants = ["network-online.target"];
        After = ["network-online.target"];
      };
    };
  };
}
