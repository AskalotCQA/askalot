module Core
  module Finder
    extend self

    def method_missing(method, *args, &block)
      _, model_name = *method.to_s.match(/\Afind_(?<model>\w+)_by\z/)

      if model_name
        model_name = model_name.classify
        model      = model_name.constantize rescue nil

        raise ArgumentError.new("Cannot find model `#{model_name}`.") unless model

        conditions = args.first

        model.find_by(conditions)
      else
        super(method, *args, &block)
      end
    end
  end
end
