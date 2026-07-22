class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.25.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.8/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "c8e73770b1d619f059e9a3b93bf28a61ff39a74bdd933af03a28750c0a521955"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.8/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "c8e73770b1d619f059e9a3b93bf28a61ff39a74bdd933af03a28750c0a521955"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.25.8/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "8e386c300786886a0b115b12869fa72f2ded1c92a839278ab096bbb736dcf049"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.25.8/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "8e386c300786886a0b115b12869fa72f2ded1c92a839278ab096bbb736dcf049"
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
