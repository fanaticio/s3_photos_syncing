require 'aws-sdk'
require 's3_photos_syncing/aws/object'
require 's3_photos_syncing/aws/transfer'
require 's3_photos_syncing/logger'

module S3PhotosSyncing
  module AWS
    def self.all_objects_from(source_bucket)
      Object.new(source_bucket).all
    end

    def self.objects_from(source_bucket, prefix=nil)
      if prefix
        objects_with_prefix_from(source_bucket, prefix)
      else
        all_objects_from(source_bucket)
      end
    end

    def self.objects_with_prefix_from(source_bucket, prefix)
      Object.new(source_bucket).all_with_prefix(prefix)
    end

    def self.transfer(object, options={})
      Transfer.new(object, options).run
    end
  end
end
