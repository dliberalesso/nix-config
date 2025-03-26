{ pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    hyperion-ng
  ];

  systemd.services.hyperion = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.hyperion-ng}/bin/hyperiond --service";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      Restart = "on-failure";
      User = "root";
      Group = "root";
      Type = "simple";
      UMask = "007";
      TimeoutStopSec = "10";
    };
  };
}
