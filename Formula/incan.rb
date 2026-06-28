# typed: false
# frozen_string_literal: true

class Incan < Formula
  desc "Statically typed language that compiles to native Rust"
  homepage "https://github.com/encero-systems/incan"
  version "0.4.0-rc2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/encero-systems/incan/releases/download/v0.4.0-rc2/incan-v0.4.0-rc2-aarch64-apple-darwin.tar.gz"
      sha256 "c9c559d3c4827af3725bf22e1d0905d63cbb336c6b8578cbd31752a10d5b73fe"
    else
      url "https://github.com/encero-systems/incan/releases/download/v0.4.0-rc2/incan-v0.4.0-rc2-x86_64-apple-darwin.tar.gz"
      sha256 "e3b96f88453ac310af75713dc30854ada656474072576dfedf8a3ffa3b93fdbb"
    end
  end

  on_linux do
      url "https://github.com/encero-systems/incan/releases/download/v0.4.0-rc2/incan-v0.4.0-rc2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d046a19bd29c3fe3ba16b876ab6b27c07372f58bc00331763af0b00551e9af84"
  end

  def staged_files
    (Dir["#{buildpath}/**/*"] + Dir["**/*"]).uniq
  end

  def staged_binary(name)
    path = staged_files.find do |candidate|
      File.basename(candidate) == name && File.basename(File.dirname(candidate)) == "bin"
    end
    path.nil? ? nil : Pathname.new(path)
  end

  def staged_file_sample
    staged_files.first(25).join(", ")
  end

  def install
    incan_bin = staged_binary("incan")
    incan_lsp_bin = staged_binary("incan-lsp")
    odie "could not find incan binary in archive; staged files: #{staged_file_sample}" if incan_bin.nil?
    odie "could not find incan-lsp binary in archive; staged files: #{staged_file_sample}" if incan_lsp_bin.nil?
    bin.install incan_bin
    bin.install incan_lsp_bin
  end

  def caveats
    <<~EOS
      Incan builds projects through Cargo. The direct, npm, and pipx installers can provision Rust automatically; Homebrew installs only the prebuilt Incan commands, so make sure rustup, cargo, rustc, and the wasm32-wasip1 target are available before running projects:
        rustup target add wasm32-wasip1
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/incan --version")
  end
end
