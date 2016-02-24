module Adebeo::ExtensionName

  def self.getUserOptions(force = false)
    #get the user option define in userOptions.json with setting in options.json
    actualFolder = File.dirname(__FILE__)
    options = Adebeo::getHashFromJsonFile "#{actualFolder}/options.json"
    userOptions = Adebeo::getHashFromJsonFile "#{actualFolder}/userOptions.json"    

    #replace defaut value of the user choice
    if userOptions
      userOptions.each{|k,v|options[k][:defauls]=v}
    else
      skipDialogBox = true
    end
    
    # if dialo
  	if not skipDialogBox || force
  	  prompts = []
  		options.each{|key,option| prompts << option[:promt]}

  		defauls = []
  		options.each{|key,option| 
  		  if option[:list] != ""
  			  indexValeurPardefaut = option[:defauls].to_i
  			  listDeValeur = option[:list].split("|")
  			  defauls << listDeValeur[indexValeurPardefaut]
  			else
  			  defauls << option[:defauls].to_s
  			end
  		} 

  		list = []
  	  options.each{|key,option| list << option[:list]}

  	  boiteDoption = UI.inputbox prompts, defauls, list, "Options..." 
      n = 0

      #Save the value inside the useroption file
      options.each{|key,option|
        value = boiteDoption[n]
        if options[key][:list] != ""
          userOptions[key] = options[key][:list].split("|").index(value)
        else
           userOptions[key] = value
        end 
        options[key][:defauls] = value
        n += 1
      }

      File.open("#{actualFolder}/userOptions.json","w") do |f|
        f.write(userOptions.to_json)
      end

    end
    
    # merge initializer and configuration
    initializer = getInitializers
    configurations = userOptions.merge(initializer)

    return configurations

  end

  def self.getInitializers(sym = true)
    # get the hash define in the configuration.json file
    # configuration are define by symbol (ex: configurations[:key]) except if sym is false
    # be careful to don't set same name in userOption and initialiser
    initializer = Adebeo::getHashFromJsonFile "#{File.dirname(__FILE__)}/initializer.json"
    return initializer
  end

end

