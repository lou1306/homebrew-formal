class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker"
  homepage "http://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.0.tar.gz"
  sha256 "75506d4ee82e2d5fcc3173059561b7636226671a8a856addcc8246347d5fa01a"
  license "Apache-2.0"

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "z3" => :build

  def install
    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake", "..", "-DZ3_DIR=#{Formula["z3"].opt_prefix}", "-DC2GOTO_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DLLVM_DIR=#{Formula["llvm"].opt_lib}/cmake/llvm", "-DClang_DIR=#{Formula["llvm"].opt_lib}/cmake/clang", "-DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES=#{HOMEBREW_PREFIX}/include:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/"
      system "make", "-j#{ENV.make_jobs}"
      system "make", "install"

      # system "cmake", "--build", ".", "--target", "install", "--", "-j#{ENV.make_jobs}"
    end
    (share/"esbmc").install "docs", "scripts", "COPYING", "CREDITS", "README.md"
  end
end
