module Adebeo

  	def Adebeo::round_by(value,precision)
   	  if precision != 0
		return (value * 10 ** precision).round.to_f / 10 ** precision
	  else
	    return (value * 10 ** precision).round.to_i / 10 ** precision
	  end
	end
  
  
	def Adebeo::log(log)
			puts log.inspect
	end

	def Adebeo::getHashFromJsonFile(jsonFilePath, sym = true)
	    # get the hash define in the jsonFilePath.json file
    	# configuration are define by symbol (ex: configurations[:key]) except if sym is false

		if !File.exist?(jsonFilePath)
	      Adebeo::log("no file : #{jsonConfigurationPath}")
	      return nil
	    end
	    jsonConfigurationFile = File.read(jsonFilePath)
	    
	    begin
	      hash = JSON.parse(jsonConfigurationFile,:symbolize_names => sym)
	    rescue JSON::ParserError
	        Adebeo::log("trouble on parsing Json from #{jsonFilePath}")
	        Adebeo::log(jsonConfigurationFile.inspect)
	        return nil
	    end
	    return hash
	end

end

