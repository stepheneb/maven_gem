$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'maven_gem/xml_utils'
require 'maven_gem/pom_spec'
require 'maven_gem/pom_fetcher'
require 'rubygems'
require 'rubygems/gem_runner'
require 'yaml'

module MavenGem
  def self.install(group, artifact = nil, version = nil)
    gem_dir, gem_file = build(group, artifact, version)
    Gem::GemRunner.new.run(["install", gem_file])
  ensure
    FileUtils.rm_f(gem_dir) if gem_dir
  end

  def self.build(group, artifact = nil, version = nil)
    if artifact
      url = MavenGem::PomSpec.to_maven_url(group, artifact, version) 
    else
      url = group
    end
    MavenGem::PomSpec.build(url)
  end
end
