require 'gcloud'

module Fluent
  module GcloudPubSub
    class Error < StandardError; end

    class Publisher
      def initialize(project, key, topic, autocreate_topic)
        pubsub = (Gcloud.new project, key).pubsub

        @client = pubsub.topic topic, autocreate: autocreate_topic
        raise Fluent::GcloudPubSub::Error "topic:#{topic} does not exist." if @client.nil?
      end

      def publish(messages)
        @client.publish do |batch|
          messages.each do |m|
            batch.publish m
          end
        end
      end
    end
  end
end
