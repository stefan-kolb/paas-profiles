require 'roo'
require 'json'
require 'date'

klass = Struct.new(:name, :revision, :vendor_verified, :url, :status, :status_since, :type, :hosting, :pricing, :scaling, :compliance, :runtimes, :frameworks, :services, :addons, :extendable, :infrastructures)

class Profile < klass
  def to_map
    map = Hash.new
    self.members.each { |m| map[m] = self[m] }
    map
  end

  def to_json(*a)
    to_map.to_json(*a)
  end
end 

class DevStatus
	BETA = "Beta"
	PRODUCTION = "Production"
	EOL = "EOL"
end

class Helper

	def self.rename_lng k
		names = [ "java", "dotnet", "python", "php", "ruby", "node" ]
		arr = []
		
		k.each do |e, i|
			arr << names[e]
		end
		
		runtimes = []
		
		arr.each do |a|
			runtimes << { :language => a, :version => "" }
		end
		runtimes
	end

	def self.rename_geo k
		names = [ "NA", "SA", "AS", "EU", "AF", "OC" ]
		arr = []
		
		k.each do |e|
			arr << names[e]
		end
		
		infras = []
		
		arr.each do |a|
			infras << { :continent => a, :country => "", :region => ""}
		end
		infras
	end

end

file = Roo::Excelx.new("Cloud Platforms (PaaS).xlsx")
file.default_sheet = file.sheets.first

entries = Hash.new

4.upto(85) do |line|
	unless file.cell(line,'Q') == DevStatus::EOL
		profile = Profile.new
		
		# name
		if file.cell(line,'B').nil?
			if file.cell(line,'C').nil?
				profile.name = file.cell(line,'D')
			else
				profile.name = file.cell(line, 'C')
			end
		else
			profile.name = file.cell(line, 'B')
		end
		
		# revision
		profile.revision = Date.today
		# status
		profile.status = file.cell(line,'Q').downcase
		# status since
		if profile.status == DevStatus::BETA.downcase
			profile.status_since = file.cell(line,'W')
		else
			profile.status_since = file.cell(line,'X')
		end
		# url
		profile.url = file.cell(line,'R')
		# type
		profile.type = file.cell(line,'F').downcase
		# hosting
		h = []
		unless file.cell(line, 'AK').nil?
			if file.cell(line, 'AK').casecmp("x")
				h << "public"
			end
		end
		unless file.cell(line, 'AL').nil?
			if file.cell(line, 'AL').casecmp("x")
				h << "private"
			end
		end
		
		profile.hosting = h
		# runtimes
		runtimes = []
		unless file.cell(line,'G').nil? 
			runtimes << 0
		end
		unless file.cell(line,'H').nil? 
			runtimes << 1
		end
		unless file.cell(line,'I').nil? 
			runtimes << 2
		end
		unless file.cell(line,'J').nil? 
			runtimes << 3
		end
		unless file.cell(line,'K').nil? 
			runtimes << 4
		end
		unless file.cell(line,'L').nil? 
			runtimes << 5
		end
		# rename
		runtimes = Helper::rename_lng runtimes
		# other
		unless file.cell(line,'M').nil?
			e = file.cell(line,'M').split ','
			runtimes.concat e.map!{|e| { :language => e.downcase.strip, "version" => "" } }
		end
		
		# extendable
		if file.cell(line, 'N').nil?
				profile.extendable = false
		else
				profile.extendable = true
		end
		
		profile.runtimes = runtimes
		
		# infras
		infras = []
		
		unless file.cell(line,'AB').nil? 
			infras << 0
		end
		unless file.cell(line,'AC').nil? 
			infras << 1
		end
		unless file.cell(line,'AD').nil? 
			infras << 2
		end
		unless file.cell(line,'AE').nil? 
			infras << 3
		end
		unless file.cell(line,'AF').nil? 
			infras << 4
		end
		unless file.cell(line,'AG').nil? 
			infras << 5
		end
		# rename
		infras = Helper::rename_geo infras
		
		profile.infrastructures = infras
		
		# scaling
		scaling = Hash.new
		if file.cell(line,'AH').nil? 
			scaling[:vertical] = false
		else
			scaling[:vertical] = true
		end
		if file.cell(line,'AI').nil? 
			scaling[:horizontal] = false
		else
			scaling[:horizontal] = true
		end
		if file.cell(line,'AJ').nil? 
			scaling[:auto] = false
		else
			scaling[:auto] = true
		end
		
		profile.scaling = scaling
		
		# verified
		profile.vendor_verified = false
		
		# pricing
		profile.pricing = file.cell(line,'AA')

		# compliance
		compliance = []
		unless file.cell(line,'AN').nil?
			e = file.cell(line,'AN').split ','
			compliance.concat e.map!{|e| e.downcase.strip }
		end
		
		profile.compliance = compliance
		
		puts JSON.pretty_generate profile

		# write json profile
		pname = profile.name.downcase.gsub(/\s/,'_')
		File.open("profiles/#{pname}.json","w") do |f|
			f.write(JSON.pretty_generate profile)
		end

	end
end