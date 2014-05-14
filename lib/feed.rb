require 'rss'

require_relative '../models/vendor/vendor'

class Feed
  def self.vendor_updates
    rss = RSS::Maker.make('atom') do |maker|
      maker.channel.title = 'PaaSify.it - Platform as a Service Providers'
      maker.channel.link = 'http://paasify.it'
      maker.channel.author = 'PaaSify.it'
      maker.channel.id = '0dfb6de0-f100-4a11-88c8-7fdc0bd5b44a'
      maker.channel.description = 'Platform as a Service provider overview, comparison and matchmaking.'
      maker.channel.updated = Time.now.to_s(:rfc822)
      maker.items.do_sort = true

      Vendor.all.each do |vendor|
        maker.items.new_item do |item|
          item.id = url_encode(vendor.name) << vendor.revision.to_s
          #item.guid.isPermaLink =false
          item.link = "http://paasify.it/vendor/#{url_encode(vendor.name)}"
          item.title = "PaaSify Update #{vendor.revision.strftime('%-m/%-d')}: #{vendor.name}"
          item.updated = vendor.revision.to_s(:rfc822)
        end


      end
    end

    rss.to_s
  end
end