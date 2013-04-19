#!/usr/bin/env jruby

$:.push File.expand_path('../../lib', __FILE__)

require 's3_photos_syncing'
require 'thor'
require 'yaml'

java_import java.util.concurrent.Executors
java_import java.util.concurrent.FutureTask

class S3PhotosSyncingScript < Thor
  desc 'start', 'Transfer objects from a bucket to another, asynchronously'
  method_option :configuration, type: :string,  required: true
  def start
    configuration_path = options[:configuration]

    unless configuration_path && File.exists?(configuration_path)
      puts %{configuration path does not exist: "#{configuration_path}"}
      exit 1
    end

    configuration = YAML.load_file(configuration_path)
    S3PhotosSyncing.run(configuration)
  end
end

S3PhotosSyncingScript.start