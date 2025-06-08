{
  description = "configuracion de neovim  ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    "plugins-snacks.nvim" = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    blade-treesitter = {
      url = "github:EmranMR/tree-sitter-blade";
      flake = false;
    };

    "plugins-laravel.nvim" = {
      url = "github:adalessa/laravel.nvim";
      flake = false;
    };

    "plugins-vague.nvim" = {
      url = "github:vague2k/vague.nvim";
      flake = false;
    };

    blink = {

      url = "github:Saghen/blink.cmp";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    phpactor-laravel = {
      url = "github:adalessa/phpactor/feature/laravel-extension";
      flake = false;
    };
    "plugins-oil-git-status.nvim" = {
      url = "github:refractalize/oil-git-status.nvim";
      flake = false;
    };
    "plugins-evangelion.nvim" = {
      url = "github:xero/evangelion.nvim";
      flake = false;
    };
    "plugins-breadcrumbs.nvim" = {
      url = "github:LunarVim/breadcrumbs.nvim";
      flake = false;
    };
  };
  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      extra_pkg_config = {
        allowUnfree = true;
      };
      dependencyOverlays = # (import ./overlays inputs) ++
        [
          # (utils.standardPluginOverlay inputs)
          (utils.sanitizedPluginOverlay inputs)
          # add any other flake overlays here.

          # when other people mess up their overlays by wrapping them with system,
          # you may instead call this function on their overlay.
          # it will check if it has the system in the set, and if so return the desired overlay
          # (utils.fixSystemizedOverlay inputs.codeium.overlays
          #   (system: inputs.codeium.overlays.${system}.default)
          # )
        ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkNvimPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = {
            laravel = with pkgs; [
               phpactor
              # intelephense
              #(pkgs.php.buildComposerProject (finalAttrs: {
               # pname = "phpactor";
                #version = "master";
                #src = inputs.phpactor-laravel;
                #vendorHash = "sha256-9re+qnjcu9kqbwlxFnTtkL+wZHs+OxEax6Jl5T3c5s0=";
                #buildInputs = [ pkgs.php83 ];
             # }))
              php83
              php83Packages.composer
              blade-formatter
            ];
            general = with pkgs; [
              lua-language-server
              fzf
              nixd
              go
              gopls
              gitea
              lazygit
              ripgrep
              fd
              nixfmt-rfc-style
              nixfmt
              # tailwindcss_4
              vscode-langservers-extracted
              mermaid-cli
              d2
              plantuml
              gnuplot
            ];

            python = with pkgs; [
              python313
              python313Packages.python-lsp-server
              mypy
              ruff
            ];

            javascript = with pkgs; [
              typescript-language-server
              tailwindcss-language-server
              # emmet-ls
              emmet-language-server
            ];

            vue = with pkgs; [
              nodejs_24
              vscode-extensions.vue.volar
              typescript-language-server
              vue-language-server
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            # gitPlugins = with pkgs.neovimPlugins; [ ];

            general = with pkgs.vimPlugins; [
              vim-sleuth
              nvim-lspconfig
              fidget-nvim
              lazydev-nvim
              nvim-treesitter.withAllGrammars # para installe todo los lenguaje
              nvim-treesitter-textobjects
              # blink-cmp
              (inputs.blink.packages.${pkgs.system}.blink-cmp.overrideAttrs { pname = "blink.cmp"; })
              blink-compat
              mini-icons
              friendly-snippets
              snacks-nvim
              lualine-nvim
              vim-surround
              pkgs.neovimPlugins.vague-nvim
              direnv-vim
              luasnip
              neotest
              nvim-nio
              plenary-nvim
              FixCursorHold-nvim
              vim-dadbod
              vim-dadbod-ui
              vim-dadbod-completion
              conform-nvim
              auto-pairs
              colorizer
              gitsigns-nvim
              pkgs.neovimPlugins.evangelion-nvim
              (pkgs.vimUtils.buildVimPlugin {
                pname = "eva-darken";
                version = "1.0";
                src = pkgs.lib.cleanSource ./lua/themes/eva-darken.lua;
                unpackPhase = ":";
              })
              pkgs.neovimPlugins.breadcrumbs-nvim
              nvim-navic
              winbar-nvim
              dropbar-nvim
              dressing-nvim
            ];

            file-manager = with pkgs.vimPlugins; [
              oil-nvim
              pkgs.neovimPlugins.oil-git-status-nvim
              mini-icons
            ];

            fuzzyFinder = with pkgs.vimPlugins; [
              fzf-lua
              mini-icons
            ];

            laravel = with pkgs.vimPlugins; [
              pkgs.neovimPlugins.laravel-nvim
              plenary-nvim
              nui-nvim
              vim-dotenv
              promise-async

              (nvim-treesitter.grammarToPlugin (
                pkgs.tree-sitter.buildGrammar {
                  language = "blade";
                  version = "0.11.0";
                  src = inputs.blade-treesitter;
                }
              ))
            ];

            obsidian = with pkgs.vimPlugins; [
              obsidian-nvim
              plenary-nvim
              render-markdown-nvim
              diagram-nvim
              image-nvim
              markdown-preview-nvim
              typst-preview-nvim
            ];


          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            # gitPlugins = with pkgs.neovimPlugins; [ ];
            general = with pkgs.vimPlugins; [
            ];

          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            test = [
              ''--set CATTESTVAR2 "It worked again!"''
            ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          extraPython3Packages = {
            test = (_: [ ]);
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };
        };

      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          { pkgs, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;
              gitPlugins = true;
              customPlugins = true;
              file-manager = true;
              fuzzyFinder = true;
              laravel = true;
              obsidian = true;
              javascript = true;
              python = true;
              vue = true;
              test = true;
              example = {
                youCan = "add more than just booleans";
                toThisSet = [
                  "and the contents of this categories set"
                  "will be accessible to your lua with"
                  "nixCats('path.to.value')"
                  "see :help nixCats"
                ];
              };
            };
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "nvim";
    in

    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };

      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );

}
