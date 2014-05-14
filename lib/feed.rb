require 'rss'

require_relative '../models/vendor/vendor'

class Feed
  def self.vendor_updates
    rss = RSS::Maker.make('2.0') do |maker|
      maker.channel.title = 'PaaSify.it - Platform as a Service Providers'
      maker.channel.link = 'http://paasify.it'
      maker.channel.description = 'Platform as a Service provider overview, comparison and matchmaking.'
      maker.channel.updated = Time.now.to_s(:rfc822)
      maker.items.do_sort = true

      Vendor.all.each do |vendor|
        maker.items.new_item do |item|
          item.id = url_encode(vendor.name) << vendor.revision.to_s
          item.guid.isPermaLink =false
          item.link = "http://paasify.it/vendor/#{url_encode(vendor.name)}"
          item.title = "PaaSify Update #{vendor.revision.strftime('%-m/%-d')}: #{vendor.name}"
          item.updated = vendor.revision.to_s(:rfc822)
        end
      end
    end

    rss.to_s
  end
end