require "rxbmc/version"
require "thor"
require 'net/http'
require 'uri'
require "fileutils"
require "pstore"
require "pry"
require "json"
require 'etc'

module RXBMC
  class Controller < Thor
    desc "init", "Check for config file, and ask for ip and username etc"
    def init
      unless File.exist? "#{Etc.getpwuid.dir}/.configs/rxbmc.conf"
        FileUtils.mkdir_p "#{Etc.getpwuid.dir}/.configs/"
        setup
      else
        configuration = PStore.new("#{Etc.getpwuid.dir}/.configs/rxbmc.conf")
        configuration.transaction do
          puts "Config file already located in ~/.configs/rxbmc.conf"
        end
      end
    end

    def method_missing(m, *args, &block)
      sender = Sender.new
      sender.send(m,*args)
    end
    private
    def setup
      configuration = PStore.new("#{Etc.getpwuid.dir}/.configs/rxbmc.conf")
      ip = ask "IP/URL to XBMC server[no http]:"
      port = ask "Port[default 8080]:"
      user = ask "User[default blank]:"
      password = ask "Password[default blank]:"
      configuration.transaction do
        configuration[:ip] = ip
        configuration[:password] = password
        configuration[:port] = port
      end
    end



  end

  class Sender
    def initialize
      configuration = PStore.new("#{Etc.getpwuid.dir}/.configs/rxbmc.conf")
      ip,port,user,pass = ''
      configuration.transaction do
        ip = configuration[:ip]
        port = configuration[:port]
        user = configuration[:user]
        pass = configuration[:pass]
      end
      begin
        # create post command
        #curl -i -X POST -H "Content-type":"application/json" -d '{"jsonrpc": "2.0", "method": "XBMC.Play", "params":{ "file" : "plugin://plugin.video.youtube/?action=play_video&videoid=pTZ2Tp9yXyM" }, "id": 1}' http://media.home:8080/jsonrpc

        uri = URI.parse("http://media.home:8080/jsonrpc")
        @http = Net::HTTP.new(uri.host, uri.port)
        @request = Net::HTTP::Post.new(uri)
        @request["Content-Type"] = "application/json"

        # response = http.request(request)
        # Shortcut
        # response = Net::HTTP.post_form(uri, {"jsonrpc" =>"2.0", "Applications.SetVolume"=>"50"})
        # binding.pry
      rescue Exception => e
        puts e
      end
    end

    def volume(percent)
      data = {"jsonrpc"=>"2.0", "method"=>"Application.SetVolume", "params"=>{"volume"=>percent.to_i}, "id"=> 1}.to_json
      @request.body = data
      response = @http.request(@request)
    end
  end

end
