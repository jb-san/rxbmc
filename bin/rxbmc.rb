#!/usr/bin/env ruby
# coding: utf-8

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'rxbmc'

RXBMC::Command.execute(*ARGV)%
