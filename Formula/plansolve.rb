class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.27.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "19e862dde4d1702f35688f5daf2358f17fc8bf2f4173506c69ef199d5ca9b1ce"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.27.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "19e862dde4d1702f35688f5daf2358f17fc8bf2f4173506c69ef199d5ca9b1ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.27.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "1e40b161c006aaed5111c7ad06f61d38b95f5d29ec497816eb6b66fbc804948a"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.27.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "1e40b161c006aaed5111c7ad06f61d38b95f5d29ec497816eb6b66fbc804948a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":  {},
    "x86_64-apple-darwin":   {},
    "x86_64-pc-windows-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "plansolve" if OS.mac? && Hardware::CPU.arm?
    bin.install "plansolve" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
