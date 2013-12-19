require 'simple-navigation'

module SimpleNavigation
  module Renderer
    class Breadcrumbs < SimpleNavigation::Renderer::Base

      def render(item_container)
        content_tag(:ul, (li_tags(item_container) << github).join(''), { id: item_container.dom_id, class: 'breadcrumb' })
      end

      protected

      def li_tags(item_container)
        item_container.items.inject([]) do |list, item|
          if item.selected?
            if include_sub_navigation?(item) && !last_item?(item.sub_navigation)
              list << content_tag(:li, link_to(item.name, item.url, {method: item.method}.merge(item.html_options.except(:class,:id))) + divider)
              list.concat li_tags(item.sub_navigation)
            else
              list << content_tag(:li, item.name, { class: 'active' })
            end
          end
          list
        end
      end

      def last_item?(item_container)
        item_container.items.each do |item|
          if item.selected?
            return false
          end
        end
        return true
      end

      def divider
        '<span class="divider">/</span>'.html_safe
      end

      def github
        '<li class="pull-right">
          <small><em>We\'re Open Source!</em></small>
					<a href="https://github.com/stefan-kolb/paas-profiles" target="_blank" style="text-decoration: none; padding: 5px;">
						<img src="/img/github.png" style="width: 20px;" alt="github">
					</a>
				</li>'.html_safe
      end

    end
  end
end

SimpleNavigation.register_renderer :breadcrumbs => SimpleNavigation::Renderer::Breadcrumbs