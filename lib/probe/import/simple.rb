module Probe
  class Import
    class Simple < Probe::Import
      def import
        each do |document|
          client.public_send(action, index: index.name, type: index.type, id: document.id, body: document.to_mapping)
        end
      end
    end
  end
end
