module StackExchange
  class Document < Nokogiri::XML::SAX::Document
    attr_accessor :batch_size, :from, :to

    def initialize
      @from = StackExchange.config.document.from
      @to   = StackExchange.config.document.to
    end

    def name
      self.class.name.split(/::/).last
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

        return if from && Time.parse(attributes[:CreationDate]) < from
        return if to && Time.parse(attributes[:CreationDate]) > to

        result = process_element(attributes)

        records = Array.wrap(result)

        if records.any?
          # puts "[#{self.name}] Processed #{@count}th #{self.name.singularize.underscore} with UUID: #{attributes[:Id]}"

          @count += 1

          records.each do |record|
            @records << record if !@records.include?(record) && record.new_record?
          end

          import if @records.size >= batch_size
        end
      end
    end

    private

    def import
      models = @records.inject(Hash.new()) do |hash, record|
        (hash[record.class] ||= Array.new) << record

        hash
      end

      models.each do |model, records|
        model.import records, validate: false, timestamps: false
      end

      @records   = []
    end
  end
end
