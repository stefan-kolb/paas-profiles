require 'simple-navigation'

module SimpleNavigation
  module Renderer
    class Breadcrumbs < SimpleNavigation::Renderer::Base

      def render(item_container)
        content_tag(:ul, (li_tags(item_container) << github).join(''), id: item_container.dom_id, class: 'crumb')
      end

      protected

      def li_tags(item_container)
        item_container.items.each_with_object([]) do |item, list|
          next unless item.selected?

          if include_sub_navigation?(item) && !last_item?(item.sub_navigation)
            list << content_tag(:li, link_to(item.name, item.url, { method: item.method }.merge(item.html_options.except(:class, :id))) + divider)
            list.concat li_tags(item.sub_navigation)
          else
            list << content_tag(:li, item.name, class: 'active')
          end

        end
      end

      def last_item?(item_container)
        item_container.items.none?(&:selected?)
      end

      def divider
        '<span class="divider">/</span>'
      end

      def github
        '<li class="pull-right hidden-phone">
          <a class="github-button"
            href="https://github.com/stefan-kolb/paas-profiles"
            data-icon="octicon-mark-github"
            data-count-api="/repos/stefan-kolb/paas-profiles#stargazers_count"></a>
          <script async defer id="github-bjs" src="https://buttons.github.io/buttons.js"></script>
        </li>'
      end

    end
  end
end

SimpleNavigation.register_renderer breadcrumbs: SimpleNavigation::Renderer::Breadcrumbs
