cask "strix" do
  version "21.0.0"
  sha256 "a430e203482026cd20f2b93b9be2e8964eaf433ffbe80dbe83412ceed4a7b313"

  url "https://github.com/meyerphi/strix/releases/download/#{version}/strix-#{version}-1-x86_64-macos.tar.gz"
  name "strix"
  desc "Tool for reactive synthesis of controllers from LTL specifications"
  homepage "https://github.com/meyerphi/strix"

  binary "strix"

  caveats do
    license "https://github.com/meyerphi/strix/blob/main/LICENSE.md"
  end


end
