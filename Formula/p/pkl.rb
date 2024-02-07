class Pkl < Formula
  version "0.25.1"
  url "https://github.com/apple/pkl/archive/refs/tags/0.25.1.tar.gz"
  sha256 "f60412679a9a8a1740e81cbed89a3ca9ddc9aa2cf0c487ff8a8a9fce70c0bf4a"

  desc "a programming language for configuration"
  homepage "https://pkl-lang.org"
  license "Apache-2.0"

  env :std
  depends_on "gradle" => :build
  depends_on "openjdk@17" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    task_os = "mac"
    bin_os = "macos"
    arch = Hardware::CPU.arm? ? "Aarch64" : "Amd64"

    if OS.linux?
      task_os = "linux"
      bin_os = "linux"
    end

    system "git", "apply", "patches/graalVm23.patch" if OS.mac? && Hardware::CPU.arm?
    system "./gradlew", "--stacktrace", "#{task_os}Executable#{arch}"
    mv "pkl-cli/build/executable/pkl-#{bin_os}-#{arch.downcase!}", "pkl"
    system "bin.install", "pkl"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test pkl`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
