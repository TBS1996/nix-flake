{
  description = "A very basic flake";

inputs = {
#nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";





home-manager = {
	url = github:nix-community/home-manager;
#	release-22.05
	inputs.nixpkgs.follows = "nixpkgs";
};
 
};

    outputs = { self, nixpkgs, home-manager }:
	let 
	    system = "x86_64-linux";
	    pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	
	};
	lib = nixpkgs.lib;
    in {
	nixosConfigurations = {
	    tor = lib.nixosSystem {
		inherit system;
		modules = [
			./configuration.nix
			home-manager.nixosModules.home-manager{
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.users.tor = {
					imports = [./home.nix];
				};
			}

			];
		};
	    };
	    hmConfig = {
		tor = home-manager.lib.homeManagerConfiguration {
			inherit system pkgs;
			username = "tor";
			homeDirectory = "/home/tor";
			configuration = {
				imports = [
				./home.nix
				];
			};

		};
	    };
	};
    
}




 #   packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
 #  defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;
