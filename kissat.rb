class Kissat < Formula
  desc "Keep it simple and clean bare metal SAT solver"
  homepage "http://fmv.jku.at/kissat/"
  url "https://github.com/arminbiere/kissat/archive/refs/tags/rel-4.0.1.tar.gz"
  sha256 "4b41edf12ffa5f8e8b1986e5ad3e0bedb4d34b0ed3ecc7c13362bc7ba0aba66b"
  license "MIT"

  bottle do
    root_url "https://github.com/lou1306/homebrew-formal/releases/download/kissat-4.0.1"
    rebuild 2
    sha256 cellar: :any_skip_relocation, sonoma: "df109c23290084b0c6cb688eeb35f4f925fb9ee57ab1107bdf0937c77b6dea1a"
  end

  option "with-test", "Run test suite"

  def install
    system "./configure"
    system "make"
    system "make", "test" if build.with? "test"
    Dir.chdir("build") do
      bin.install "kissat"
      lib.install "libkissat.a"
    end
    (include/"kissat").install "src/kissat.h"
  end
end
