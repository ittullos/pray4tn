# -*- encoding: utf-8 -*-
# stub: aws-record 2.10.1 ruby lib

Gem::Specification.new do |s|
  s.name = "aws-record".freeze
  s.version = "2.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Amazon Web Services".freeze]
  s.date = "2023-01-17"
  s.description = "Provides an object mapping abstraction for Amazon DynamoDB.".freeze
  s.email = ["mamuller@amazon.com".freeze, "alexwoo@amazon.com".freeze]
  s.homepage = "https://github.com/aws/aws-sdk-ruby-record".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.rubygems_version = "3.4.3".freeze
  s.summary = "AWS Record library for Amazon DynamoDB".freeze

  s.installed_by_version = "3.4.3" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<aws-sdk-dynamodb>.freeze, ["~> 1.18"])
end
