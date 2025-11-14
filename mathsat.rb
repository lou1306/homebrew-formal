require "macho"

class Mathsat < Formula
  desc "Efficient Satisfiability Modulo Theories (SMT) solver"
  homepage "http://mathsat.fbk.eu/index.html"
  url "https://mathsat.fbk.eu/release/mathsat-5.6.14-macos.tar.gz"
  sha256 "e839462862dc2abc6975ad84e8cd25a4f854046597d6f73fa7f245ab9ae30b00"
  license :cannot_represent

  depends_on "gmp"
  depends_on "python-setuptools"
  depends_on "python@3"

  def install
    pyver = `python3 --version 2>&1 | awk '{print $2}'`.chomp.gsub(/([0-9]+).([0-9]+).([0-9]+)/, '\1.\2')
    pylocal = (lib/"python#{pyver}/site-packages")
    mkdir_p pylocal.to_s
    # Compile Python bindings.
    Dir.chdir "python" do
      system "python", "setup.py", "build"
      pylocal.install "mathsat.py", Dir["build/lib*/_mathsat*.so"]
    end

    # Install MathSat.
    bin.install "bin/mathsat"
    include.install Dir["include/*.h"]
    lib.install "lib/libmathsat.a"
    (share/"mathsat").install "configurations", "examples", "LICENSE.txt", "README.txt"

    # Compile and install Java library.
    Dir.chdir "java" do
      inreplace "compile.sh" do |s|
        s.gsub!(/^MATHSAT_DIR=.*/, "MATHSAT_DIR=#{prefix}")
        s.gsub!(/^JAVA_DIR=.*/, "JAVA_DIR=`/usr/libexec/java_home`")
        s.gsub!(/^GMP_INCLUDE_DIR=.*/, "GMP_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include")
        s.gsub!(/^GMP_LIB_DIR=.*/, "GMP_LIB_DIR=#{HOMEBREW_PREFIX}/lib")
        s.gsub! "soname", "install_name"
        s.gsub! "linux", "darwin"
        s.gsub! ".so", ".dylib"
        s.gsub! "CC  -pthread", "CC -Wno-int-conversion -Wno-incompatible-pointer-types-discards-qualifiers -pthread"
      end
      system "./compile.sh || (cat compile.log && false)"
      MachO.codesign!("libmathsatj.dylib") if Hardware::CPU.arm?
      lib.install "libmathsatj.dylib"
      libexec.install "mathsat.jar"
    end
    File.open("mathsatj-compile", "w") do |f|
      f.puts("#!/bin/sh\n")
      f.puts("`/usr/libexec/java_home`/bin/javac -cp #{HOMEBREW_PREFIX}/lib/mathsat.jar \"$@\"")
    end
    File.open("mathsatj-run", "w") do |f|
      f.puts("#!/bin/sh\n")
      f.puts("DYLD_LIBRARY_PATH=.:#{HOMEBREW_PREFIX}/lib `/usr/libexec/java_home`/bin/java ")
      f.puts("-cp .:#{HOMEBREW_PREFIX}/lib/mathsat.jar \"$@\"")
    end
    bin.install "mathsatj-compile", "mathsatj-run"
  end

  def caveats
    <<~EOS
      To compile a Java file Test.java with mathsat, run
        $ mathsatj-compile Test.java

      To run the class Test.class, run
        $ mathsatj-run Test

      === LICENSE ===
      #{Utils.safe_popen_read "cat", "#{HOMEBREW_PREFIX}/share/mathsat/LICENSE.txt"}===============

      The license can be found in #{HOMEBREW_PREFIX}/share/mathsat/LICENSE.txt
    EOS
  end
end
