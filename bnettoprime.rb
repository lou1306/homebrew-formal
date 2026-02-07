class Bnettoprime < Formula
  desc "Tool for obtaining prime implicants of regulatory functions in a Boolean Network"
  homepage "https://github.com/xstreck1/BNetToPrime"
  url "https://github.com/xstreck1/BNetToPrime/archive/ad7a5a952b94d190253b95180cb0115d6d81df99.tar.gz"
  version "1.0"
  sha256 "ae4abd53de484b9061e007c31ccbeb31ea22bce59768d8ca3828c8d3c407228d"
  license "AGPL-3.0"

  def install
    system ENV.cxx, "-o", "BNetToPrime", "main.cpp"
    bin.install "BNetToPrime"
    prefix.install "README.md", "LICENSE"
  end
end
