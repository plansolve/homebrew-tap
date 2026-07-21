class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.25.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.4/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "ad7f757a2c5f027c5c3b0a4e63449d2319b191eb4e236fafd62783fb468596b7"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.4/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "ad7f757a2c5f027c5c3b0a4e63449d2319b191eb4e236fafd62783fb468596b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.4/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "638cd578805156fde6c541bcb31462c603cb04db90c6ddbb62d41bd13e7b997f"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.4/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "638cd578805156fde6c541bcb31462c603cb04db90c6ddbb62d41bd13e7b997f"
    end
  end
  license "MIT"

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
