require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'asciidoctor'
  gem 'asciidoctor-html5s'
end

puts "Hello world, you're an asshole."
puts "asciidoctor version is #{Asciidoctor::VERSION}"
puts "HTML5s extension version is #{Asciidoctor::Html5s::VERSION}"
