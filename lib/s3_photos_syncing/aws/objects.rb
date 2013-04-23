require 'aws-sdk'

module S3PhotosSyncing
  module AWS
    class Objects
      def initialize(source_bucket)
        @source_bucket = source_bucket
      end

      def all
        source.objects
      end

      def all_with_prefix(prefix)
        all.with_prefix(prefix)
      end

      def source
        @source ||= ::AWS::S3.new.buckets[@source_bucket]
      end
    end
  end
end
