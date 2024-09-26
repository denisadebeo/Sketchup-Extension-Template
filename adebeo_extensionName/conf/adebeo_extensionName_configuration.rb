module Adebeo::ExtensionName

  def self.getUserOptions(force = false)

    #get the user option define in userOptions.json with setting in options.json

    actualFolder = __dir__.dup
    actualFolder.force_encoding('UTF-8') if actualFolder.respond_to?(:force_encoding)

    options = Adebeo::get_hash_from_json_file "#{actualFolder}/options.json"
    userOptions = Adebeo::get_hash_from_json_file "#{actualFolder}/userOptions.json"
    skipDialogBox = true
    #replace defaut value of the user choice
    if userOptions
      userOptions.each{|k,v|options[k][:defauls]=v}
    else
      skipDialogBox = false
    end

    # if dialo
  	if not skipDialogBox or force
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

    actualFolder = __dir__.dup
    actualFolder.force_encoding('UTF-8') if actualFolder.respond_to?(:force_encoding)

    initializer = Adebeo::get_hash_from_json_file "#{actualFolder}/initializer.json"
    return initializer
  end

end
