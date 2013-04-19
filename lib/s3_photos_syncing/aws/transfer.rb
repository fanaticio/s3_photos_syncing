require 'aws-sdk'
require 's3_photos_syncing/logger'

module S3PhotosSyncing
  module AWS
    class Transfer
      def initialize(object, options)
        @object             = object
        @source_bucket      = options[:from]
        @destination_bucket = options[:to]
      end

      def destination
        @destination ||= ::AWS::S3.new.buckets[@destination_bucket]
      end

      def destination_object
        @destination_object ||= destination.objects[@object.key]
      end

      def run
        unless valid_source_object?
          Logger.info("invalid extension #{source_object.key}")
          return
        end

        if destination_object.exists?
          Logger.info("already copied #{source_object.key}")
          return
        end

        Logger.info("copying #{source_object.key}")
        begin
          destination_object.copy_from(source_object.key, bucket: source, acl: :public_read)
          Logger.info("copied #{source_object.key}")
        rescue Exception => error
          Logger.error("error on copy #{source_object.key}: #{error}")
        end
      end

      # TODO: use file format from options and add specs
      def file_format
        /\.jp[e]?g$/i
      end

      def source
        @source ||= ::AWS::S3.new.buckets[@source_bucket]
      end

      def source_object
        @object
      end

      def valid_source_object?
        !!(source_object.key =~ file_format)
      end
    end
  end
end