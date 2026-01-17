{
  unify.modules.laptop.nixos =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        libva-utils
        vdpauinfo
        vulkan-tools
      ];
    };
}
