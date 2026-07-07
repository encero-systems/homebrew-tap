# typed: false
# frozen_string_literal: true

class Incan < Formula
  desc "Statically typed language that compiles to native Rust"
  homepage "https://github.com/encero-systems/incan"
  version "0.4.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/encero-systems/incan/releases/download/v0.4.0/incan-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "f1cc83611de33808b609f814c9cec7fe59c0e3315e2767f65ecda9c71e9b966a"
    else
      url "https://github.com/encero-systems/incan/releases/download/v0.4.0/incan-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "f5f4b13c85b0823b1d517a3ac618441e7147eb9987f1f3450bcefbe26fabca70"
    end
  end

  on_linux do
      url "https://github.com/encero-systems/incan/releases/download/v0.4.0/incan-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f39e941e3fc0c817de9656b78b1c8899ef226784f095f9fff02efac3f06562b0"
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
    stdlib_dir = Pathname.new("stdlib")
    odie "could not find incan binary in archive; staged files: #{staged_file_sample}" if incan_bin.nil?
    odie "could not find incan-lsp binary in archive; staged files: #{staged_file_sample}" if incan_lsp_bin.nil?
    odie "could not find stdlib/testing.incn in archive; staged files: #{staged_file_sample}" unless (stdlib_dir/"testing.incn").exist?
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/incan"
    bin.write_exec_script libexec/"bin/incan-lsp"
  end

  def caveats
    <<~EOS
      Incan builds projects through Cargo. The direct, npm, and pipx installers can provision Rust automatically; Homebrew installs the prebuilt Incan commands and bundled stdlib sources, so make sure rustup, cargo, rustc, and the wasm32-wasip1 target are available before running projects:
        rustup target add wasm32-wasip1
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/incan --version")
  end
end
