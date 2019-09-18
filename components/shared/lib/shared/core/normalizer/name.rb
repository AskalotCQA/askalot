module Shared::Core
  module Normalizer
    module Name
      extend self

      def normalize(value)
        value = value.to_s
        copy  = value.clone
        value = value.utf8

        prefixes  = []
        suffixes  = []
        additions = []
        uppercase = []
        mixedcase = []
        flags     = []

        value.strip!
        value.gsub!(/[\,\;\(\)]/, '')
        value.gsub!(/(\.+\s*)+/, '. ')
        value.gsub!(/\s*\-\s*/, '-')

        value.split(/\s+/).each do |part|
          key = map_key(part)

          if prefix = prefix_map[key]
            prefixes << prefix
          elsif suffix = suffix_map[key]
            suffixes << suffix
          else
            part = part.utf8.strip

            if part =~ /\./
              if part =~ /rod\./i
                flags << :born
              elsif part =~ /(ml|st)\./
                flags << :relative
                additions << part
              end
            else
              if part.upcase == part
                uppercase << part.split(/\-/).map(&:titlecase).join('-')
              else
                mixedcase << part.split(/\-/).map(&:titlecase).join('-')
              end
            end
          end
        end

        prefixes.uniq!
        suffixes.uniq!

        names = mixedcase + uppercase

        if flags.include? :born
          names << names.last
          names[-2] = 'rod.'
        end

        value = nil
        value = names.join(' ')                   unless names.empty?
        value = prefixes.join(' ') + ' ' + value  unless prefixes.empty?
        value = value + ' ' + additions.join(' ') unless additions.empty?
        value = value + ', ' + suffixes.join(' ') unless suffixes.empty?

        {
          unprocessed: copy.strip,
          value:       value,
          prefix:      prefixes.empty? ? nil : prefixes.join(' '),
          first:       names.count >= 2 ? names.first.to_s : nil,
          middle:      names.count >= 3 ? names[1..-2].join(' ') : nil,
          last:        names.last.to_s,
          suffix:      suffixes.empty? ? nil : suffixes.join(' '),
          addition:    additions.empty? ? nil : additions.join(' '),
          flags:       flags,
        }
      end

      def prefix_map
        @prefix_map ||= map_using ['abs. v. š.', 'akad.', 'akad. arch.',
        'akad. mal.', 'akad. soch.', 'arch.', 'Bc.', 'Bc. arch.', 'BcA.',
        'B.Ed.', 'B.Sc.', 'Bw. (VWA)', 'doc.', 'Dr.', 'Dr hab.', 'Dr inž.',
        'Dr. jur.', 'Dr.h.c.', 'Dr.ir.', 'Dr.phil.', 'Eng.', 'ICDr.', 'Ing.',
        'Ing. arch.', 'JUC.', 'JUDr.', 'Kfm.', 'Kfm. (FH)', 'Lic.', 'Mag',
        'Mag.', 'Mag. (FH)', 'Mag. iur', 'Magistra Artium', 'Mag.rer.nat.',
        'MDDr.', 'MgA.', 'Mgr.', 'Mgr. art.', 'mgr inž.', 'Mgr. phil.',
        'MMag.', 'Mr.sc.', 'MSDr.', 'MUc.', 'MUDr.', 'MVc.', 'MVDr.',
        'PaedDr.', 'PharmDr.', 'PhDr.', 'PhMr.', 'prof.', 'prof. mpx. h.c.',
        'prof.h.c.', 'RCDr.', 'RNDr.', 'RSDr.', 'ThDr.', 'ThLic.']
      end

      def suffix_map
        @suffix_map ||= map_using ['ArtD.', 'BA', 'BA (Hons)', 'BBA', 'BBS',
        'BBus', 'BBus (Hons)', 'BS', 'BSBA', 'BSc', 'Cert Mgmt', 'CPA', 'CSc.',
        'DDr.', 'Dipl. Ing.', 'Dipl. Kfm.', 'Dipl.ECEIM', 'DiS.', 'DiS.art',
        'Dr.', 'Dr.h.c.', 'DrSc.', 'DSc.', 'EMBA', 'E.M.M.', 'Eqm.', 'Litt.D.',
        'LL.A.', 'LL.B.', 'LL.M.', 'M.A.', 'MAE', 'MAS', 'MBA', 'MBSc',
        'M.C.L.', 'MEng.', 'MIM', 'MMBA', 'MPH', 'M.Phil.', 'MS', 'MSc',
        'M.S.Ed.', 'Ph.D.', 'PhD.', 'prom. biol.', 'prom. ek.', 'prom. fil.',
        'prom. filol.', 'prom. fyz.', 'prom. geog.', 'prom. geol.',
        'prom. hist.', 'prom. chem.', 'prom. knih.', 'prom. logop.',
        'prom. mat.', 'prom. nov.', 'prom. ped.', 'prom. pharm.',
        'prom. práv.', 'prom. psych.', 'prom. vet.', 'prom. zub.', 'ThD.']
      end

      private

      def map_using(values)
        values.inject({}) { |m, v| m[map_key(v)] = v; m }
      end

      def map_key(value)
        value.ascii.downcase.gsub(/[\s\.\,\;\-\(\)]/, '').to_sym
      end
    end
  end
end
