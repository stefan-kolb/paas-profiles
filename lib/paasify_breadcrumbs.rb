require 'simple-navigation'

module SimpleNavigation
  module Renderer
    class PaasifyBreadcrumbs < SimpleNavigation::Renderer::Base

      def render(item_container)
        content_tag(:ul, (li_tags(item_container) << github).join(''), { id: item_container.dom_id, class: "breadcrumb" })
      end

      protected

      def li_tags(item_container)
        item_container.items.inject([]) do |list, item|
          if item.selected?
            if include_sub_navigation?(item)
              list << content_tag(:li, link_to(item.name, item.url, {method: item.method}.merge(item.html_options.except(:class,:id))) + divider) if item.selected?
              list.concat li_tags(item.sub_navigation)
            else
              list << content_tag(:li, item.name, { class: 'active' }) if item.selected?
            end
          end
          list
        end
      end

      def divider
        '<span class="divider">/</span>'.html_safe
      end

      def github
        '<li class="pull-right">
          <small><em>We\'re Open Source!</em></small>
					<a href="https://github.com/stefan-kolb/paas-profiles" target="_blank" style="text-decoration: none; padding: 5px;">
						<img src="/img/github.png" style="width: 20px;">
					</a>
				</li>'
      end

    end
  end
end
SimpleNavigation.register_renderer :breadcrumbs => SimpleNavigation::Renderer::PaasifyBreadcrumbs