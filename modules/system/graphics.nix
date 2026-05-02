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

      hardware.graphics.extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
    };
}
