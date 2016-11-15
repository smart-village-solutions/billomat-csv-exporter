# encoding: utf-8

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'billomat_csv_exporter/version'

Gem::Specification.new do |spec|
  spec.name          = "billomat_csv_exporter"
  spec.version       = BillomatCsvExporter::VERSION
  spec.authors       = ["Marco Metz"]
  spec.email         = ["marco.metz@gmail.com"]
  spec.summary       = %q{billomat csv exporter}
  spec.description   = %q{export all Invoices including all items to an csv file}
  spec.homepage      = "https://github.com/ikuseiGmbH/billomat-csv-exporter"
  spec.license       = "GNU GENERAL PUBLIC LICENSE"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "addressable"
  spec.add_development_dependency "nokogiri"

end
