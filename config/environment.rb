ENVIRONMENT = ENV['RACK_ENV'] || 'development'

require 'rubygems'
require 'bundler/setup'
require 'sinatra'

unless $:.include? File.expand_path('/../', __FILE__)
  $:.unshift File.expand_path('/../', __FILE__)
end

Dir['config/initializers/*.rb'].each { |file| require file }
Dir['app/**/*.rb'].each { |file| require file }
