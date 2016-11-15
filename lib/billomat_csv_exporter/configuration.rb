module BillomatCsvExporter
  class Configuration
    @config = {
              x_app_id: "",
              x_app_secret: "",
              x_billomat_api_key: "",
              accept_language: "de-de",
              host: "yourname.billomat.net",
              csv: {
                encoding: "UTF8",
                col_sep: ";"
              }
            }

    @valid_config_keys = @config.keys

    # Configure through hash
    def self.configure(opts = {})
      opts.each {|k,v| @config[k.to_s] = v if @valid_config_keys.include? k.to_s}
    end

    # Configure through yaml file
    def self.configure_with_path
      if defined?(::Rails).nil?
        path_to_yaml_file = "../config/billomat_exporter.yml"
      else
        path_to_yaml_file = "#{::Rails.root}/config/billomat_exporter.yml"
      end
      begin
        config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        puts "YAML configuration file couldn't be found. Using defaults."
        return
      rescue Psych::SyntaxError
        puts "YAML configuration file contains invalid syntax. Using defaults."
        return
      end

      configure(config)
    end

    def self.config
      @config
    end
  end
end
