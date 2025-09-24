require 'formula'

class Picosat < Formula
  homepage "http://fmv.jku.at/picosat/"
  url "http://fmv.jku.at/picosat/picosat-965.tar.gz"
  sha256 "15169b4f28ba8f628f353f6f75a100845cdef4a2244f101a02b6e5a26e46a754"

  patch :DATA

  def install
    system "./configure.sh", "-shared"
    system "make"
    bin.install "picosat", "picogcnf", "picomcs", "picomus"
    lib.install "libpicosat.a", "libpicosat.dylib"
    include.install "picosat.h"
  end
end


__END__
diff --git a/configure.sh b/configure.sh
index ca5ec77..fe9e162 100755
--- a/configure.sh
+++ b/configure.sh
@@ -108,7 +108,7 @@ fi
 TARGETS="picosat picomcs picomus picogcnf libpicosat.a"
 if [ $shared = yes ]
 then
-  TARGETS="$TARGETS libpicosat.so"
+  TARGETS="$TARGETS libpicosat.dylib"
   CFLAGS="$CFLAGS -fPIC"
 fi
 echo "targets ... $TARGETS"
diff --git a/makefile.in b/makefile.in
index 2eb0af2..76ffa05 100644
--- a/makefile.in
+++ b/makefile.in
@@ -52,8 +52,7 @@ libpicosat.a: picosat.o version.o
 	ar rc $@ picosat.o version.o
 	ranlib $@
 
-SONAME=-Xlinker -soname -Xlinker libpicosat.so
-libpicosat.so: picosat.o version.o
-	$(CC) $(CFLAGS) -shared -o $@ picosat.o version.o $(SONAME)
+libpicosat.dylib: picosat.o version.o
+	$(CC) $(CFLAGS) -shared -install_name $@ -o $@ picosat.o version.o
 
 .PHONY: all clean
