# hosts/thinkpad-x1/variables.nix
{
  username    = "maksim";
  hostname    = "maksim-pc";
  timezone    = "Asia/Ho_Chi_Minh";
  gitName      = "Maksim Vorontsov";
  gitEmail     = "social.maksim.vrs@gmail.com";
  gitWorkEmail = "maksim.vorontsov@zemomedia.com";
  # WARNING: stateVersion must never be changed after the first install.
  # Changing it can silently corrupt stateful services.
  stateVersion = "25.05";
}
