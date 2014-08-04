require 'json'
require 'RMagick'

module IoHelper
  def write_json_file(filename, data)
    File.open(filename, 'w') do |f|
      f.write(JSON.pretty_generate data)
    end
  end

  def write_png_image(filename, data)
    image = Magick::Image.from_blob(data).first
    image.format = 'PNG'
    image.write(filename << '.png')
  end

  def to_filename(str)
    str.downcase.gsub(/[^a-z0-9]/, '_')
  end
end