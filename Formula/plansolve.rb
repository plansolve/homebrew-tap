class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.25.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.2/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "8c3162377ffe878f26c58d4aea8c8cbbe06a3abaf321779f4aea0925f2cdd9a9"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.2/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "8c3162377ffe878f26c58d4aea8c8cbbe06a3abaf321779f4aea0925f2cdd9a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.2/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "c24f340d6f9b32187edd948c16015d0f514df8cfec8209af522ad96937fc0cdb"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.2/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "c24f340d6f9b32187edd948c16015d0f514df8cfec8209af522ad96937fc0cdb"
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
