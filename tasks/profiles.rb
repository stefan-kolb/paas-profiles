namespace :profiles do

  desc "Sorts all entries in the profiles"
  task :sort do
    # import files
    Dir.glob("./profiles#{File::SEPARATOR}/**/*.json").each do |file_name|
      begin
        data = JSON.parse(File.read(file_name))
        # sort
        data['runtimes'].sort_by! { |r| r['language'] } unless data['runtimes'].blank?
        data['middleware'].sort_by! { |m| m['name'] } unless data['middleware'].blank?
        data['frameworks'].sort_by! { |f| f['name'] } unless data['frameworks'].blank?
        unless data['services'].blank?
          data['services']['native'].sort_by! { |n| n['name'] } unless data['services']['native'].blank?
          data['services']['addon'].sort_by! { |a| a['name'] } unless data['services']['addon'].blank?
        end
        data['infrastructures'].sort_by! { |c| c['continent'] } unless data['infrastructures'].blank?
        # save file
        File.open(file_name, "w") do |f|
          f.write(JSON.pretty_generate(data))
        end
      rescue
        raise "An error occurred while sorting #{file_name}"
      end
    end
  end

  desc "Tries to autocomplete missing values"
  task :complete do
    # import files
    Dir.glob("./profiles#{File::SEPARATOR}/**/*.json").each do |file_name|
      begin
        data = JSON.parse(File.read(file_name))

        # services
        unless data['services'].blank?
          data['services']['native'].each do |s|
            if s['type'].blank?
              puts "[MISSING] #{data['name']} #{s['name']} is missing service type"
              alt = Vendor.ne(name: data['name']).find_by('services.native.name' => /#{s['name']}/)
              type = alt['services']['native'].select { |v| v['name'] =~ /#{s['name']}/ }[0]
              puts "What about #{type['type']}? (y/n)"
              accept = STDIN.gets.chomp()
              if accept.eql? 'y'
                s['type'] = type['type']
              end
            end
          end
        end

        # addons
        unless data['services'].blank?
          data['services']['addon'].each do |s|
=begin
            # type
            if s['type'].blank?
              puts "[MISSING] #{data['name']} #{s['name']} is missing addon type"
              alt = Vendor.ne(name: data['name']).find_by('services.addon.name' => /#{s['name']}/)
              type = alt['services']['addon'].select { |v| v['name'] =~ /#{s['name']}/ }[0]
              puts "What about #{type['type']}? (y/n)"
              accept = STDIN.gets.chomp()
              if accept.eql? 'y'
                s['type'] = type['type']
              end
            end
=end
            # url
            if s['url'].blank?
              puts "[MISSING] #{data['name']} #{s['name']} is missing addon url"
              begin
                alt = Vendor.ne(name: data['name']).where('services.addon.name' => /#{s['name']}/, 'services.addon.url' => { '$ne' => ''}, 'services.addon.url' => { '$exists' => true })
                type = alt[0]['services']['addon'].select { |v| v['name'] =~ /#{s['name']}/ }[0] unless alt.blank?
                puts "What about #{type['url']} (y/n)"
                accept = STDIN.gets.chomp()
                if accept.eql? 'y'
                  s['url'] = type['url']
                end
              rescue Exception => e
                puts e.message
                # nothing to do
              end
            end
          end
        end

        # save file
        File.open(file_name, "w") do |f|
          f.write(JSON.pretty_generate(data))
        end
      rescue Exception => e
        puts e.message
        raise "An error occurred while trying to autocomplete #{file_name}"
      end
    end
  end

  desc "Updates Heroku Addons"
  task :update do
    # get addons
    response = RestClient.get('https://api.heroku.com/addon-services', {'Accept' => 'application/vnd.heroku+json; version=3' })
    recent = JSON.parse(response.body)
    profile = JSON.parse(File.read("./profiles/heroku.json"))

    puts "Recent #{recent.size}, Old #{profile['services']['addon'].size}"
    # check if included
    recent.each do |a|
      reg = a['name'].gsub(/[\s_-]/, '.')
      reg = reg.gsub(/(.{1})(?=.)/, '\1(.)?\2')
      unless profile['services']['addon'].detect { |i| i['name'] =~ /#{reg}/i }
        puts "Potentially new add-on #{a['name']}"
        puts 'Add (y/n)?'
        accept = STDIN.gets.chomp()
        if accept.eql? 'y'
          profile['services']['addon'] << { "name" => a['name'], "url" => "", "type" => "" }
        end
      end
    end

    # remove old
    profile['services']['addon'].each do |a|
      reg = a['name'].gsub(/[\s_-]/, '.')
      reg = reg.gsub(/(.{1})(?=.)/, '\1(.)?\2')
      unless recent.detect { |i| i['name'] =~ /#{reg}/i } || recent.detect { |i| i['name'] =~ /#{a['name'].gsub(/[\s_-]/, '')}/i }
        puts "Potentially removed add-on #{a['name']}"
        puts 'Delete (y/n)?'
        accept = STDIN.gets.chomp()
        if accept.eql? 'y'
          profile['services']['addon'].delete(a)
        end
      end
    end

    # save file
    File.open("./profiles/heroku.json", "w") do |f|
      f.write(JSON.pretty_generate(profile))
    end
  end

end