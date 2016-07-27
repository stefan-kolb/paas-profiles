require 'rss'

require_relative '../app/models/vendor/vendor'
require_relative '../app/helpers/application_helpers'

module Profiles
  class Feed
    extend ApplicationHelpers

    class << self
      def rss
        rss = RSS::Maker.make('2.0') do |feed|
          feed.channel.title = 'PaaSfinder.org - Platform as a Service Providers'
          feed.channel.link = 'https://paasfinder.org'
          feed.channel.description = 'Platform as a Service provider overview, comparison and matchmaking.'
          feed.items.do_sort = true

          create_entries(feed)
        end

        rss.to_s
      end

      private

      def create_entries(feed)
        Vendor.all.each do |vendor|
          feed.items.new_item do |item|
            item.title = "PaaSfinder Update #{vendor.revision.strftime('%-m/%-d')}: #{vendor.name}"
            item.guid.content = url_encode(vendor.name) << vendor.revision.to_s
            item.guid.isPermaLink = false
            item.link = "https://paasfinder.org/vendors/#{url_encode(vendor.name)}"
            item.updated = vendor.revision.to_s(:rfc822)
          end
        end
      end

    end
  end
end
