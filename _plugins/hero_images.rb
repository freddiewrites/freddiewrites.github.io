# Sets page.hero for posts with their own `image:`, with the image's real
# width and height read from the file. The post layout uses these for the
# srcset width descriptor and the width/height attributes, so the hero shows
# at full width on high-density screens and doesn't shift the page as it loads.
#
# Runs before og_cards.rb, which replaces `image` with a preview card for
# posts that don't have their own.

module HeroImages
  DEFAULT_IMAGE = "/assets/images/social-image.png"

  class Generator < Jekyll::Generator
    priority :low

    def generate(site)
      site.posts.docs.each do |post|
        image = post.data["image"]
        path = image.is_a?(Hash) ? image["path"] : image
        next if path.nil? || path == DEFAULT_IMAGE

        width, height = HeroImages.dimensions(File.join(site.source, path))
        post.data["hero"] = { "path" => path, "width" => width, "height" => height }
      end
    end
  end

  # Width and height of a JPEG or PNG, read from the file header. Returns
  # [nil, nil] if the file is missing or in another format.
  def self.dimensions(file)
    return [nil, nil] unless File.file?(file)

    File.open(file, "rb") do |f|
      header = f.read(24)
      if header&.start_with?("\x89PNG".b)
        return header[16, 8].unpack("NN")
      elsif header&.start_with?("\xFF\xD8".b)
        f.seek(2)
        while (marker = f.read(2)) && marker.getbyte(0) == 0xFF
          type = marker.getbyte(1)
          length = f.read(2).unpack1("n")
          # Start-of-frame markers hold the dimensions (C4, C8 and CC are not frames)
          if (0xC0..0xCF).cover?(type) && ![0xC4, 0xC8, 0xCC].include?(type)
            height, width = f.read(5).unpack("xnn")
            return [width, height]
          end
          f.seek(length - 2, IO::SEEK_CUR)
        end
      end
    end
    [nil, nil]
  end
end
