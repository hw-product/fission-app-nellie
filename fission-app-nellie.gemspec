$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'fission-app-nellie/version'
Gem::Specification.new do |s|
  s.name = 'fission-app-nellie'
  s.version = FissionApp::Nellie::VERSION.version
  s.summary = 'Fission App Nellie'
  s.author = 'Heavywater'
  s.email = 'fission@hw-ops.com'
  s.homepage = 'http://github.com/hw-product/fission-app-nellie'
  s.description = 'Fission nellie'
  s.require_path = 'lib'
  s.add_dependency 'fission-app'
  s.add_dependency 'fission-app-jobs'
  s.files = Dir['{lib,app,config}/**/**/*'] + %w(fission-app-nellie.gemspec README.md CHANGELOG.md)
end
