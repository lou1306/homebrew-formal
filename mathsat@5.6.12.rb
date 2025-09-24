class MathsatAT5612 < Formula
  desc "Efficient Satisfiability Modulo Theories (SMT) solver"
  homepage "http://mathsat.fbk.eu/index.html"
  url "https://mathsat.fbk.eu/release/mathsat-5.6.12-macos.tar.gz"
  sha256 "28fe0711bdd920217af706b07983f033470efc2ea15a4563397e1a930b75e9f5"

  def install
    # Install MathSat.
    bin.install "bin/mathsat" => "mathsat-5.6.12"
    include.install "include/mathsat.h" => "mathsat-5.6.12.h"
    include.install "include/mathsatll.h" => "mathsatll-5.6.12.h"
    include.install "include/msatexistelim.h" => "msatexistelim-5.6.12.h"
    lib.install "lib/libmathsat.a" => "libmathsat-5.6.12.h"
    (share/"mathsat@5.6.12").install "configurations", "examples"
  end
end
