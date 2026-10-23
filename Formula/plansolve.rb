class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.38.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.38.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "08bc9ac5676cb86fe8bb36d8eeb7c0c867e748f2c519aa1bf6355d12807083c4"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.38.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "08bc9ac5676cb86fe8bb36d8eeb7c0c867e748f2c519aa1bf6355d12807083c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.38.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "1b42494b4dbe8ad6db2427a03e7b17e3232f526b53376a82ea9fc2cabb1f52af"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.38.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "1b42494b4dbe8ad6db2427a03e7b17e3232f526b53376a82ea9fc2cabb1f52af"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "plansolve"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "plansolve"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
