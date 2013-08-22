# Rakefile

require 'fileutils'
require 'pathname'
require 'yaml'
require 'erb'
require 'mime/types'
require 'kramdown'
require './assets/lib/book.rb'
require './assets/lib/chapter.rb'
require './assets/lib/manifest.rb'

require 'pry'
require 'awesome_print'

@config = YAML::load(IO.read('book.yml'))
@book = nil

task :default => :question

task :question do
  puts "Please specify a task."
end

task :epub => [
  'assets:compass',
  'epub:clean',
  'epub:generate_build',
  'epub:compile',
]

task :mobi => [
  'assets:compass',
  'mobi:clean',
  'mobi:generate_build',
  'mobi:compile',
]

task :latex => [
  'latex:clean',
  'latex:generate_build',
  'latex:compile',
]

namespace :assets do
  task :compass do
    sh 'cd assets && compass compile'
  end
end

namespace :epub do

  task :clean do
    @book ||= epub_init_book
    clean_dir(@book.build_dir)
  end

  task :generate_build do
    @book ||= epub_init_book
    @book.generate_build
  end

  task :compile do
    @book ||= epub_init_book
    path = File.expand_path("./publish/epub/#{@book.compile_name}.epub")
    sh "cd #{@book.build_dir} && zip -X #{path} mimetype"
    sh "cd #{@book.build_dir} && zip -rg #{path} META-INF"
    sh "cd #{@book.build_dir} && zip -rg #{path} OEBPS"
  end

  task :check do
    puts "epub:check"
    #@book ||= epub_init_book
    #sh "java -jar #{@config['epubcheck_path']} #{@book.build_dir} -mode exp -out err.xml"
  end

end

namespace :mobi do

  task :clean do
    @book ||= mobi_init_book
    clean_dir(@book.build_dir)
  end

  task :generate_build do
    @book ||= mobi_init_book
    @book.generate_build
  end

  task :compile do
    @book ||= mobi_init_book
    path = File.expand_path("./#{@book.compile_name}.epub")

    sh "cd #{@book.build_dir} && zip -X #{path} mimetype"
    sh "cd #{@book.build_dir} && zip -rg #{path} META-INF"
    sh "cd #{@book.build_dir} && zip -rg #{path} OEBPS"

    sh "kindlegen '#{@book.compile_name}.epub' -c2 -o '#{@book.compile_name}.mobi'"
    sh "mv '#{@book.compile_name}.mobi' ./publish/mobi/"
    sh "rm '#{@book.compile_name}.epub'"
  end

end

namespace :latex do

  task :clean  do
    @book ||= latex_init_book
    clean_dir(@book.build_dir)
  end

  task :generate_build  do
    @book ||= latex_init_book
    @book.generate_build
  end

  task :compile do
    @book ||= latex_init_book
    sh "cd #{@book.build_dir} && make"
  end

end

def epub_init_book
  [ './config/epub_mobi.yml',
    './config/epub.yml' ].each do |c|
    h = YAML::load(IO.read(c))
    @config.merge!(h) if h
  end

  @config['output_format'] ||= 'epub'
  @config['template_dir'] ||= './assets/epub_template/'
  @config['build_dir'] ||= './build/epub/'

  VolumeOne::Book.new(@config)
end

def mobi_init_book
  [ './config/epub_mobi.yml',
    './config/mobi.yml' ].each do |c|
    h = YAML::load(IO.read(c))
    @config.merge!(h) if h
  end

  @config['output_format'] ||= 'mobi'
  @config['template_dir'] ||= './assets/epub_template/'
  @config['build_dir'] ||= './build/mobi/'

  VolumeOne::Book.new(@config)
end

def latex_init_book
  [ './config/latex.yml', ].each do |c|
    h = YAML::load(IO.read(c))
    @config.merge!(h) if h
  end

  @config['output_format'] ||= 'latex'
  @config['template_dir'] ||= './assets/latex_template/'
  @config['build_dir'] ||= './build/latex/'

  @book = VolumeOne::Book.new(@config)
end

def clean_dir(dir)
  if Dir[File.join(dir, '*')].empty?
    puts "#{dir} is empty."
    return
  end
  print "Delete everything in #{dir} ? [yN] "
  a = STDIN.gets.chomp()
  if a.downcase != 'y'
    puts "Cancelled, bye!"
    exit
  end
  sh "rm -rf #{File.join(dir, '*')}"
end

# task :concat_tex do
#   content = ""
#   BOOK['toc'].each do |t|
#     if t.is_a?(String)
#       content << IO.read(File.join(BOOK['tex-base-dir'], t)) << "\n\n"
#     elsif t.is_a?(Hash)
#       content << '\chapter{' + t['title'] + '}' + "\n\n"
#       content << IO.read(File.join(BOOK['tex-base-dir'], t['tex'])) << "\n\n"
#     elsif t.is_a?(List)
#       puts "hey List"
#     end
#   end
#   File.open('content.tex', 'w'){|f| f << content }
# end
#
#task :convert_tex_to_xhtml do
#  sh 'pandoc --smart --normalize --from=latex --to=html -o content.xhtml content.tex'
#end

