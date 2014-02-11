module Core
  module Builder
    extend self

    def method_missing(method, *args, &block)
      _, model_name = *method.to_s.match(/\Acreate_(?<model>\w+)_by\z/)

      if model_name
        model_name = model_name.classify
        model      = model_name.constantize rescue nil

        raise ArgumentError.new("Cannot find model '#{model_name}'.") unless model

        keys       = args[0..-2]
        attributes = args.last
        conditions = attributes.slice(*keys)

        record = model.find_or_initialize_by(conditions)

        record.update_attributes!(attributes)

        record
      else
        super(method, *args, &block)
      end
    end
  end
end
