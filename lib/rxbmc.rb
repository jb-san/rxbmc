require "rxbmc/version"

module Rxbmc


  class Client < Thor
    desc "hej från clienten"
    def hej(name)
      puts "hej #{name}"

    end

  end

end
