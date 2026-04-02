# hosts/thinkpad-x1/variables.nix
{
  username    = "maksim";
  hostname    = "maksim-pc";
  timezone    = "Asia/Almaty";
  gitName     = "Maksim Vorontsov";
  gitEmail    = "maksim.vorontsov@zemomedia.com";
  # WARNING: stateVersion must never be changed after the first install.
  # Changing it can silently corrupt stateful services.
  stateVersion = "25.05";
}
