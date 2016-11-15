module BillomatCsvExporter
  class Base

    FIELDS_TO_EXPORT = %w{
      id created client_id contact_id invoice_number number
      number_pre title date supply_date supply_date_type due_date due_days address
      status discount_rate discount_date discount_days discount_amount label intro
      note total_gross total_net currency_code quote net_gross reduction
      total_gross_unreduced total_net_unreduced paid_amount open_amount payment_types
    }

    ITEMS_TO_EXPORT = %w{ position unit quantity unit_price title total_net total_gross }

    def initialize(opts={}, &block)
      @config = BillomatCsvExporter::Configuration.configure_with_path
      @logfile = File.open( File.expand_path("billomat_export.csv"), "w" )
      @headers = {
        "X-AppId" => @config["x_app_id"],
        "X-AppSecret" => @config["x_app_secret"],
        "X-BillomatApiKey" => @config["x_billomat_api_key"],
        "Accept-Language" => @config["accept_language"],
        "Accept" => "text/xml"
      }
      import
    end

    def import
      invoices = load_all_invoices

      add_header_to_csv

      invoices.each do |invoice|
        invoice_items = get_invoice_items(invoice.at_xpath("id").text)
        # puts invoice.at_xpath("id").text
        # puts invoice_items.inspect

        data = []
        invoice_items.each do |invoice_item|
          FIELDS_TO_EXPORT.each do |field|
            data << parse_text(invoice.at_xpath(field).text)
          end
          ITEMS_TO_EXPORT.each do |item|
            data << parse_text(invoice_item.at_xpath(item).text)
          end
          append_entry_to_file(data)
        end
      end

      @logfile.close
    end

    def add_header_to_csv
      @logfile.puts (FIELDS_TO_EXPORT + ITEMS_TO_EXPORT).flatten.join(@config["csv"]["col_sep"])
    end

    def append_entry_to_file(data = [])
      @logfile.puts data.flatten.join(@config["csv"]["col_sep"])
    end

    def parse_text(text)
      text = text.gsub("\r\n", ", ")
      "\"#{text}\""
    end

    def load_all_invoices
      params = {
        "per_page" => "10000",
        "order_by" => "invoice_number"
      }

      url = [@config["host"], "/api/invoices"].join()
      request = BillomatCsvExporter::ApiRequestService.new(url,
                                                           @config["port"],
                                                           params,
                                                           @headers)
      result = request.get_request
      xml = Nokogiri.XML(result.body)
      xml.xpath("//invoice")
    end

    def get_invoice_items(id)
      params = { "invoice_id" => id }

      url = [@config["host"], "/api/invoice-items"].join()
      request = BillomatCsvExporter::ApiRequestService.new(url,
                                                           @config["port"],
                                                           params,
                                                           @headers)
      result = request.get_request
      xml = Nokogiri.XML(result.body)
      xml.xpath("//invoice-item")
    end


  end
end
