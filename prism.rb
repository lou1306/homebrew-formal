class Prism < Formula
  desc "Probabilistic model checker"
  homepage "http://www.prismmodelchecker.org"
  url "https://www.prismmodelchecker.org/dl/prism-4.9-src.tar.gz"
  sha256 "a78813114cdb29bf26902edc60d7b0dc58b75fd370c9d04ca672f2a031bc4cd1"
  depends_on "openjdk"

  def install
    Dir.chdir "cudd" do
      inreplace "util/util.h", "#define fail(why)", "#define cuddfail(why)"
    end

    Dir.chdir "prism" do
      ENV.append_to_cflags("-I#{HOMEBREW_PREFIX}/opt/openjdk/include")
      system "OSTYPE=darwin make release"

      Dir.chdir "release" do
        Dir["prism-*.tar.gz"].each do |tgz|
          system "tar", "zxf", tgz
          Dir.chdir tgz.sub(".tar.gz", "") do
            (share/"prism").install Dir["*"]
          end
        end
      end
      (share/"prism").install "etc/"
    end
    Dir.chdir share/"prism" do
      system "./install.sh"
    end
    bin.install Dir[share/"prism/bin/*"]

    Dir[share/"prism/lib/*.dylib"].each do |dylib|
      MachO::Tools.dylibs(dylib).each do |dep|
        next unless dep.start_with?("../../lib/", "bin/osx64")

        MachO::Tools.change_install_name(dylib, dep, dep.sub("../../lib/", "./").sub("bin/osx64/", "./"))
      end
    end

    ohai "The PRISM package is installed in #{HOMEBREW_PREFIX}/share/prism."
  end

  test do
    path = share/"prism/etc/tests/"
    system bin/"prism", path/"dtmc_pctl.prism", path/"dtmc_pctl.prism.props", "-ex", "-test"
    system bin/"prism", path/"dtmc_pctl.prism", path/"dtmc_pctl.prism.props", "-h", "-test"
    system bin/"prism", path/"test_lpsolve_mdpmo.prism", path/"test_lpsolve_mdpmo.prism.props", "-lp", "-test"
  end
end
