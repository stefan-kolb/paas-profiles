namespace :assets do

  desc 'Retrieves vendor logos from Twitter'
  task :vendor do
    puts '----> Retrieving vendor logos...'
    get_icons(:vendor)
  end

  desc 'Retrieves framework logos from Twitter'
  task :frameworks do
    puts '----> Retrieving framework logos...'
    get_icons(:frameworks)
  end

  desc 'Retrieves add-on logos from Twitter'
  task :addons do
    puts '----> Retrieving addon logos...'
    get_icons(:addons)
  end

  desc 'Retrieves service logos from Twitter'
  task :services do
    puts '----> Retrieving service logos...'
    get_icons(:services)
  end

  desc 'Creates sprites for each image folder'
  task :sprites do
    puts '----> Creating sprites...'
    # http://glue.readthedocs.org/en/latest/options.html
    cmd = 'glue public/sources --img=public/img/sprites --css=public/css/sprites --retina --margin=1 --project'
    %x[ #{cmd} ]
  end

  private

  def get_icons(type)
    data = JSON.parse(File.read("data/twitter_#{type}.json"))
    mkdir_p("public/sources/#{type}") unless File.exists?("public/sources/#{type}")
    get_twitter_images(data, type)
    rm_rf("public/sources/#{type}")
    # write data file
    write_json_file("data/twitter_#{type}.json", data)
  end

  def get_twitter_images(data, type)
    data.each do |vendor|
      unless vendor['twitter'].blank?
        begin
          # FIXME limit is 180
          resp = RestClient.get("https://api.twitter.com/1.1/users/show.json?screen_name=#{vendor['twitter']}", :'authorization' => "Bearer #{ENV['TWITTER_SECRET']}")

          unless resp.code == 200
            fail 'Bad response'
          end

          profile = JSON.parse(resp.body)
          # normal image URL
          img_url = profile['profile_image_url_https']
          vendor['image'] = img_url

          # download largest image version
          img_url.gsub!('normal', '400x400')
          write_png_image("public/sources/#{type}/" << to_filename(vendor['vendor']), open(img_url).read)

          # process image
          image = Magick::Image.read("public/sources/#{type}/" << to_filename(vendor['vendor']) << '.png').first

          if type.eql? :vendor
            file_path = 'public/img/vendor/' << to_filename(vendor['vendor'])
            # small
            small = image.scale(80,80)
            small.write(file_path + '.png')
            # large
            image.write(file_path + '_big.png')
          else
            # prepare for sprites
            image.scale!(80,80)
            image.write("public/sources/#{type}/" << to_filename(vendor['vendor']) << '.png')
          end

        rescue Exception => ex
          puts "Error retrieving image of #{vendor['vendor']}."
          puts ex.message
          puts 'Consider that rate limiting is 15 minutes!'
        end
      end
    end
  end

end