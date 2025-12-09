require "macho"

class Mathsat < Formula
  desc "Efficient Satisfiability Modulo Theories (SMT) solver"
  homepage "http://mathsat.fbk.eu/index.html"
  url "https://mathsat.fbk.eu/release/mathsat-5.6.15-macos.tar.gz"
  sha256 "470441be2208ffd57290e81d8ab14119935c1120b8d7a34bc7dbe8b2a4e1cf1c"
  license :cannot_represent
  option "without-java", "Skip building and installation of Java bindings"

  depends_on "gmp"
  depends_on "python-setuptools" => :recommended
  depends_on "python@3" => :recommended

  def install
    if build.with? "python-setuptools"
      ohai "Compile and install Python bindings"
      pyver = `python3 --version 2>&1 | awk '{print $2}'`.chomp.gsub(/([0-9]+).([0-9]+).([0-9]+)/, '\1.\2')
      pylocal = (lib/"python#{pyver}/site-packages")
      mkdir_p pylocal.to_s
      # Compile Python bindings.
      Dir.chdir "python" do
        system "python", "setup.py", "build"
        pylocal.install "mathsat.py", Dir["build/lib*/_mathsat*.so"]
      end
    end

    # Install MathSat.
    bin.install "bin/mathsat"
    include.install Dir["include/*.h"]
    lib.install "lib/libmathsat.a"
    (share/"mathsat").install "configurations", "examples", "LICENSE.txt", "README.txt"

    # Compile and install Java library.
    if build.with? "java"
      ohai "Compile and install Java bindings"
      cflags = "-Wno-int-conversion -Wno-incompatible-pointer-types-discards-qualifiers"
      Dir.chdir "java" do
        inreplace "compile.sh" do |s|
          s.gsub!(/^MATHSAT_DIR=.*/, "MATHSAT_DIR=#{prefix}")
          s.gsub!(/^JAVA_DIR=.*/, "JAVA_DIR=`/usr/libexec/java_home`")
          s.gsub!(/^GMP_INCLUDE_DIR=.*/, "GMP_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include")
          s.gsub!(/^GMP_LIB_DIR=.*/, "GMP_LIB_DIR=#{HOMEBREW_PREFIX}/lib")
          s.gsub! "soname", "install_name"
          s.gsub! "linux", "darwin"
          s.gsub! ".so", ".dylib"
          s.gsub! "CC  -pthread", "CC #{cflags} -pthread"
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
    puts <<~EOS
      To compile a Java file Test.java with mathsat, run
        $ mathsatj-compile Test.java

      To run the class Test.class, run
        $ mathsatj-run Test
    EOS
  end

  def caveats
    <<~EOS
      === LICENSE ===
      MathSAT5 is copyrighted 2009-2025 by Fondazione Bruno Kessler, Trento, Italy,
      University of Trento, Italy, and others. All rights reserved.

      MathSAT5 is available for research and evaluation purposes only.
      It can not be used in a commercial environment, particularly as part of a
      commercial product, without written permission. MathSAT5 is provided as is,
      without any warranty.

      Please write to mathsat@fbk.eu for additional questions regarding licensing
      MathSAT5 or obtaining more up-to-date versions.
      ===============
    EOS
  end
end
