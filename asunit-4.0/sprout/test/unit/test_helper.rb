require "rubygems"
require "bundler"

Bundler.require :default, :development

# These require statments *must* be in this order:
# http://bit.ly/bCC0Ew
# Somewhat surprised they're not being required by Bundler...
require 'shoulda'
require 'mocha'
require 'test/unit'

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'asunit4')
$:.unshift File.dirname(__FILE__)

require 'sprout/test/sprout_test_case'

