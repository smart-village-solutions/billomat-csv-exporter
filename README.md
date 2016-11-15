# billomat-csv-exporter
export all Invoices including all items to an csv file

# Configure Settings

copy /config/billomat_exporter.yml.tmpl => /config/billomat_exporter.yml

# Install Dependencies

`bundle install`

# Start rails console by typing

`rake console`

# Start exporter

`BillomatCsvExporter.new`


# Result

Now there should by a CSV File called billomat_exporter.csv in your home dir
