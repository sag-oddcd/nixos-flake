{ config, ... }:

{
  # Docker with NVIDIA support
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };
}
