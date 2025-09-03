{
  unify.modules.laptop.nixos = {
    services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  };
}
