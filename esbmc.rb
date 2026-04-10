class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker"
  homepage "https://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.1.tar.gz"
  sha256 "b68bd9e8fd254dc390f644ee3cd2d1c24e0d4bfd21675d9939017f7683b785fc"
  license "Apache-2.0"

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm@21" => :build
  depends_on "z3" => :build

  def install
    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake", "..",
        "-DZ3_DIR=#{Formula["z3"].opt_prefix}",
        "-DC2GOTO_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}",
        "-DLLVM_DIR=#{Formula["llvm@21"].opt_lib}/cmake/llvm",
        "-DClang_DIR=#{Formula["llvm@21"].opt_lib}/cmake/clang",
        "-DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES=#{HOMEBREW_PREFIX}/include:" \
        "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/"
      system "make", "-j#{ENV.make_jobs}"
      system "make", "install"
    end
    (share/"esbmc").install "docs", "scripts", "COPYING", "CREDITS", "README.md"
  end
end
