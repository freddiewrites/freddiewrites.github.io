# Assigns each post and page a generated preview card (1200x630) for link
# previews, and writes the list of cards to draw. scripts/og_cards.py draws
# them into _site after the build (see .github/workflows/jekyll.yml).
#
# - Posts with their own `image:` keep it as their preview and hero.
# - The homepage keeps the default fh image set in _config.yml.
# - Everything else with a title gets a card: posts, pages and tag pages.
#   Now updates are skipped, since they only appear on /now/.

require "cgi"
require "json"

module OgCards
  DEFAULT_IMAGE = "/assets/images/social-image.png"
  CARD_DIR = "/assets/og"

  class Generator < Jekyll::Generator
    # Run after jekyll-archives has created the tag pages
    priority :lowest

    def generate(site)
      smarty = site.find_converter_instance(Jekyll::Converters::SmartyPants)
      cards = []

      site.posts.docs.each do |post|
        own = own_image(post.data["image"])
        post.data["hero"] = own
        # Now updates only appear on /now/, which gets its own card
        next if own || title_of(post).empty? || Array(post.data["tags"]).include?("now")

        cards << assign(post, smarty)
      end

      site.pages.each do |page|
        next unless page.html? && page.data["layout"] && page.data["layout"] != "home"
        next if title_of(page).empty?
        next if own_image(page.data["image"])

        cards << assign(page, smarty)
      end

      site.config["og_cards"] = cards
    end

    private

    # Tag pages keep their name in #title rather than in front matter
    def title_of(item)
      archive = defined?(Jekyll::Archives::Archive) && item.is_a?(Jekyll::Archives::Archive)
      title = archive ? item.title.to_s.split(/(\W+)/).map(&:capitalize).join : item.data["title"].to_s
      title.strip
    end

    # The image the author set in front matter, or nil for none or the default
    def own_image(image)
      path = image.is_a?(Hash) ? image["path"] : image
      path unless path.nil? || path == DEFAULT_IMAGE
    end

    def assign(item, smarty)
      title = CGI.unescapeHTML(smarty.convert(title_of(item))).strip
      name = item.url.gsub(%r{^/|/$}, "").gsub(%r{[/.]}, "-")
      path = "#{CARD_DIR}/#{name}.png"
      item.data["image"] = { "path" => path, "width" => 1200, "height" => 630, "alt" => title }
      { "title" => title, "path" => path }
    end
  end
end

# Write the list outside _site so it isn't published
Jekyll::Hooks.register :site, :post_write do |site|
  cache = File.join(site.source, ".jekyll-cache")
  FileUtils.mkdir_p(cache)
  File.write(File.join(cache, "og-cards.json"), JSON.pretty_generate(site.config["og_cards"] || []))
end
