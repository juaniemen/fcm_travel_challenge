require 'minitest/autorun'
require 'time'
Dir[File.join(__dir__, '../source/**/*.rb')].sort.each { |file| require file }
