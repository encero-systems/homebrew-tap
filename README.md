# Encero Systems Homebrew Tap

This tap provides Homebrew formulae for Encero Systems tools.

Install Incan:

```sh
brew tap encero-systems/tap
brew install incan
```

Incan builds projects through Cargo. The Homebrew formula installs the prebuilt `incan` and `incan-lsp` commands; make sure Rust and the `wasm32-wasip1` target are available before building packages that need vocab companions:

```sh
rustup target add wasm32-wasip1
```
