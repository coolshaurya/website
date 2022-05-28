require 'bundler/inline'
require 'fileutils'

gemfile do
    source 'https://rubygems.org'
    gem 'asciidoctor'
    gem 'asciidoctor-html5s'
    gem 'mustache'
end

OUT_DIRECTORY = "./out"
MUSTACHE_CONFIG = {
    template_path: "./templates",
    template_extension: "mst",
}
ASCIIDOCTOR_CONFIG = {
    converter: Asciidoctor::Html5s::Converter,
    standalone: false,
}

def pipeline(file_list, asciidoctor_config, template_file)
    mustache_instance = Mustache.new
    mustache_instance.template_path = MUSTACHE_CONFIG[:template_path]
    mustache_instance.template_extension = MUSTACHE_CONFIG[:template_extension]
    mustache_instance.template_file = template_file

    file_list.map do |file_name|
        contents = File.read file_name
        document = Asciidoctor.load contents, asciidoctor_config
        mustache_attrs = document.attributes.merge({content: document.convert})
        
        final_output = mustache_instance.render mustache_attrs
        new_name = "#{OUT_DIRECTORY}/#{File.dirname file_name}/#{File.basename file_name, '.*'}.html"
        FileUtils.mkdir_p File.dirname(new_name)
        File.write new_name, final_output
    end
end

FileUtils.mkdir_p OUT_DIRECTORY
FileUtils.rm_r Dir.glob("#{OUT_DIRECTORY}/**")
FileUtils.cp_r "./resources/", OUT_DIRECTORY

pipeline ["index.adoc"],
ASCIIDOCTOR_CONFIG,
"./templates/home.mst"

pipeline Dir.glob("articles/**.adoc"),
ASCIIDOCTOR_CONFIG,
"./templates/article.mst"
