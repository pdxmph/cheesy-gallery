# frozen_string_literal: true

require 'rmagick'
require 'cheesy-gallery/base_image_file'

# This StaticFile subclass adds additional functionality for images in the
# gallery
class CheesyGallery::ImageFile < CheesyGallery::BaseImageFile
  def initialize(site, collection, file)
    super

    # read file metadata in the same way it will be processed
    Jekyll.logger.debug 'Identifying:', path
    source = Magick::Image.ping(path).first
    source.change_geometry!('1920x1080') do |cols, rows, _img|
      data['height'] = rows
      data['width'] = cols
    end
  end

  # instead of copying, renders an optimised version
  def process_and_write(img, path)
    img.change_geometry!('1920x1080') do |cols, rows, i|
      i.resize!(cols, rows)
    end
    img.write(path) { self.quality = 50 }
  end
end
