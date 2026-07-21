class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.25.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "d0ad81ee7616af8015737d090a70fc3c5aeeff97c7a4a7a1085a297ed09a9270"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "d0ad81ee7616af8015737d090a70fc3c5aeeff97c7a4a7a1085a297ed09a9270"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "3a37bc3333bfd610a33e2c378b548b1983e01ef4a0b469b0309bccbdc1876bd4"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "3a37bc3333bfd610a33e2c378b548b1983e01ef4a0b469b0309bccbdc1876bd4"
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
