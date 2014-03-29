module StackExchange
  class Document < Nokogiri::XML::SAX::Document
    attr_accessor :model, :batch_size

    def name
      self.class.name
    end

    def batch_size
      @batch_size ||= 1000
    end

    def start_document
      puts "[#{self.name}] Starting processing ..."

      @count      = 0
      @started_at = Time.now
      @records    = []
    end

    def end_document
      import

      puts "[#{self.name}] Ended processing (#{Time.now - @started_at}s)"
    end

    def start_element(name, attributes = [])
      if name == 'row'
        attributes = Hash[attributes].symbolize_keys
        record     = process_element(attributes)

        if record
          puts "[#{self.name}] Processed #{@count}th #{model.name} with ID: #{attributes[:Id]}"

          @count += 1

          @records << record

          import if @records.size >= batch_size
        end
      end
    end

    private

    def import
      model.import @records, validate: false, timestamps: true

      @records = []
    end
  end
end
