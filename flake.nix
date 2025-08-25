{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cloudflared
            air

            sops

            gopls
            golangci-lint

            shfmt
          ];
          nativeBuildInputs = with pkgs; [ go ];
          buildInputs = with pkgs; [
            imagemagick
            curl
            ffmpeg
            rush-parallel
            findutils
          ];
        };
      }
    );
}
