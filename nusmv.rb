class Nusmv < Formula
  env :std
  desc "Software tool for the formal verification of finite state systems"
  homepage "http://nusmv.fbk.eu"
  url "https://nusmv.fbk.eu/distrib/2.7.1/NuSMV-2.7.1.tar.xz"
  sha256 "f1e11931f71d98aa9b84181eed67db584d7111100c2e967c904a31c15f823f60"
  depends_on "meson" => :build
  depends_on "lou1306/formal/cudd"

  def install
    ohai "Compile NuSMV"
    mkdir_p "build"
    system "meson", "setup", "build"
    system "meson", "compile", "-C", "build"
    ohai "Install NuSMV"
    chdir "build" do
      bin.install "ltl2smv"
      bin.install "NuSMV"
    end

    (lib/"nusmv").install Dir["build/*.a"]
    (share/"nusmv").install "contrib", "examples", "README.md"
    (include/"nusmv").install Dir["code/**/*.h"]
    (lib/"pkgconfig").install Dir["build/meson-private/*.pc"]
  end

  test do
    system bin/"nusmv", share/"nusmv/examples/smv-dist/counter.smv"
    system bin/"nusmv", share/"nusmv/examples/smv-dist/mutex.smv"
    system bin/"nusmv", share/"nusmv/examples/smv-dist/ring.smv"
    system bin/"nusmv", share/"nusmv/examples/smv-dist/short.smv"
  end
end
