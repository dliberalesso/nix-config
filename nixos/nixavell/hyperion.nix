{ pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    hyperion-ng
  ];

  #FIXME: json path should come from the store
  systemd.services.hyperion = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.hyperion-ng}/bin/hyperiond --userdata /tmp/hyperion --service #/etc/nix/hyperion.json";
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
