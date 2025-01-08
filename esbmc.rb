class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker (ESBMC)"
  homepage "http://esbmc.org/"
  url "https://github.com/esbmc/esbmc.git",
    tag:      "v7.8",
    revision: "961ffe5a1a11b430edbf809e0acee0c13280dfaa"
  license "Apache-2.0"

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "z3" => :build

  # The patch will:
  # - Force the script to install boolector
  # - remove `brew install`
  # - fix calls to `brew prefix`
  # - remove last call to make
  patch :DATA

  def install
    system "./build-esbmc-mac.sh"
    Dir.chdir "build" do
      system "make"
      bin.install "src/esbmc/esbmc"
    end
    (share/"esbmc").install "docs", "scripts", "COPYING", "CREDITS", "README.md"
  end
end
__END__
diff --git a/build-esbmc-mac.sh b/build-esbmc-mac.sh
index 6c0d3c788..efdee22a6 100755
--- a/build-esbmc-mac.sh
+++ b/build-esbmc-mac.sh
@@ -1,33 +1,20 @@
 #!/bin/bash
 
-# Check if Homebrew is installed
-if ! command -v brew &> /dev/null; then
-    echo "Error: Homebrew is not installed!"
-    echo "Please install Homebrew first by running this command:"
-    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
-    echo "After installing Homebrew, run this script again."
-    exit 1
-fi
-
 # Ask about Boolector right at the start (Y/yes is default)
-read -p "Do you want to install the recommended Boolector solver? [Y/n]: " use_boolector
-use_boolector=${use_boolector:-Y}  # Default to Y if user just hits enter
+use_boolector="Y"
 
 # Create and enter build directory
 echo "Creating build directory..."
 mkdir -p build
 cd build
 
-echo "Installing ESBMC dependencies..."
-brew install z3 bison clang llvm
-
 # Get number of CPUs and add 1
 CPU_COUNT=$(($(sysctl -n hw.ncpu) + 1))
 
 # Get paths
-PATH_LLVM=$(brew --prefix llvm)
+PATH_LLVM=HOMEBREW_PREFIX/opt/llvm
 PATH_SDK=$(xcrun --show-sdk-path)
-PATH_Z3=$(brew --prefix z3)
+PATH_Z3=HOMEBREW_PREFIX/opt/z3
 
 # Function to install Boolector
 install_boolector() {
@@ -65,10 +52,3 @@ else
         -DClang_DIR="$PATH_LLVM/lib/cmake/clang"
 fi
 
-echo "Running make..."
-make -j${CPU_COUNT}
-
-echo "Installing ESBMC system-wide (requires sudo permission)..."
-sudo make install
-
-echo "Build and installation complete! You can now run 'esbmc' from anywhere."
