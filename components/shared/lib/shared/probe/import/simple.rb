module Shared::Probe
  class Import
    class Simple < Shared::Probe::Import
      def import
        each do |document|
          client.public_send(action, index: index.name, type: index.type, id: document.id, body: document_for_import(document))
        end
      end
    end
  end
end
