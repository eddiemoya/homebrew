require 'formula'

class Siege < Formula
  homepage 'http://www.joedog.org/index/siege-home'
  url "https://raw.github.com/tail/siege/ddff13ee54057446223cc8b80fac61d96dcda095/siege-beta.tar.gz"
  sha1 '3376b8a8875909f514daa8dbd8563321bb0ebde1'

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix+'etc').mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Mac OS X has only 16K ports available that won't be released until socket
    TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds.
    Consider reducing in case of available port bottleneck.

    You can check whether this is a problem with netstat:

        # sysctl net.inet.tcp.msl
        net.inet.tcp.msl: 15000

        # sudo sysctl -w net.inet.tcp.msl=1000
        net.inet.tcp.msl: 15000 -> 1000

    Run siege.config to create the ~/.siegerc config file.
    EOS
  end
end
