module BillomatCsvExporter
  class Base
    def initialize(opts={}, &block)
      Configuration.configure_with_path
    end

    def config
      Configuration.config
    end

    def create(uniq_id, data_to_save=[])
      #if config["logfile_destination"] == "local"

    end


  end
end
