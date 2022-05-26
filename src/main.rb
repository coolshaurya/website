require 'bundler/inline'

gemfile do
    source 'https://rubygems.org'
    gem 'asciidoctor'
    gem 'asciidoctor-html5s'
    gem 'mustache'
end

OUT_DIRECTORY = "./out"

def pipeline(file_list, asciidoctor_config, mustache_config)
    mustache_instance = Mustache.new
    mustache_instance.template_file = mustache_config[:template_file]
    mustache_instance.template_path = mustache_config[:template_path]
    mustache_instance.template_extension = mustache_config[:template_extension]

    file_list.map do |file_name|
        contents = File.read file_name
        document = Asciidoctor.load contents, asciidoctor_config
        mustache_attrs = document.attributes.merge({content: document.convert})
        puts mustache_instance.render mustache_attrs
        new_name = "#{OUT_DIRECTORY}/#{File.dirname file_name}/#{File.basename file_name, '.*'}.html"
    end
end

asciidoctor_config = {
    converter: Asciidoctor::Html5s::Converter,
    standalone: false,
}

mustache_config = {
    template_path: "./templates",
    template_extension: "mst",
    template_file: "./templates/article.mst",
}

pipeline Dir.glob("articles/**.adoc"), asciidoctor_config, mustache_config
