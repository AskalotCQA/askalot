class MigrateCategoriesToHierarchy < ActiveRecord::Migration
  def up
    categories = Shared::Category.roots.where.not name: 'root'

    root = Shared::Category.roots.find_by! name: 'root'

    years = root.children

    subjects = {}

    subject_grade_mapping = {
        "2013-14" => {
            "PSI" => "bc-2-rocnik",
            "DBS" => "bc-2-rocnik",
            "FLP" => "bc-2-rocnik",
            "OOP" => "bc-1-rocnik",
        },
        "2014-15" => {
            "ALG" => "ing-1-2-rocnik",
            "AASS" => "ing-1-2-rocnik",
            "AMOBS" => "ing-1-2-rocnik",
            "ARCHP" => "bc-1-rocnik",
            "ASEMBL" => "bc-1-rocnik",
            "BVI" => "ing-1-2-rocnik",
            "DBS" => "bc-2-rocnik",
            "DDS" => "bc-3-rocnik",
            "DPRS" => "ing-1-2-rocnik",
            "ELTCH" => "bc-1-rocnik",
            "EA" => "ing-1-2-rocnik",
            "FMAN" => "ing-1-2-rocnik",
            "FLP" => "bc-2-rocnik",
            "FYZ" => "bc-1-rocnik",
            "GRA" => "ing-1-2-rocnik",
            "KDK" => "bc-3-rocnik",
            "KPAIS" => "ing-1-2-rocnik",
            "MBIT" => "ing-1-2-rocnik",
            "MSS" => "bc-3-rocnik",
            "ML1" => "bc-1-rocnik",
            "MIKROP" => "bc-2-rocnik",
            "NDS" => "ing-1-2-rocnik",
            "NGNSSP" => "ing-1-2-rocnik",
            "OZNAL" => "ing-1-2-rocnik",
            "OOANS" => "ing-1-2-rocnik",
            "OOP" => "bc-1-rocnik",
            "PKS" => "bc-2-rocnik",
            "PVID" => "ing-1-2-rocnik",
            "PAM" => "bc-1-rocnik",
            "PAS" => "bc-1-rocnik",
            "PIS" => "bc-3-rocnik",
            "PSI" => "bc-2-rocnik",
            "PSFYZ" => "bc-1-rocnik",
            "PAP" => "bc-2-rocnik",
            "RETOR" => "ing-1-2-rocnik",
            "SATSYS" => "ing-1-2-rocnik",
            "SB" => "ing-1-2-rocnik",
            "SSIIT" => "ing-1-2-rocnik",
            "SIPVS" => "ing-1-2-rocnik",
            "STOCHM" => "ing-1-2-rocnik",
            "TEAP" => "bc-2-rocnik",
            "UI" => "bc-2-rocnik",
            "UMA" => "4bc-1-rocnik",
            "VPT" => "ing-1-2-rocnik",
            "VD" => "ing-1-2-rocnik",
            "VCMA" => "bc-1-rocnik",
            "VAVA" => "bc-2-rocnik",
            "WANT" => "ing-1-2-rocnik",
            "ZPS" => "4bc-1-rocnik",
            "ZPRPR2" => "4bc-1-rocnik",
            "ZTIAPL" => "4bc-1-rocnik",
            "ADM" => "bc-1-rocnik",
            "AZA" => "bc-2-rocnik",
            "AJ" => "bc-1-rocnik",
            "AIS" => "ing-1-2-rocnik",
            "APS" => "ing-1-2-rocnik",
            "ASS" => "ing-1-2-rocnik",
            "AOVS" => "ing-1-2-rocnik",
            "BP" => "bc-3-rocnik",
            "BKS" => "ing-1-2-rocnik",
            "BMIS" => "ing-1-2-rocnik",
            "BPS" => "ing-1-2-rocnik",
            "DSA" => "bc-2-rocnik",
            "DD" => "ing-1-2-rocnik",
            "DP" => "ing-1-2-rocnik",
            "ELN" => "bc-2-rocnik",
            "IVZDEL" => "4bc-1-rocnik",
            "ICP" => "bc-3-rocnik",
            "KOD" => "ing-1-2-rocnik",
            "KSS" => "ing-1-2-rocnik",
            "KMPS" => "ing-1-2-rocnik",
            "LO" => "bc-1-rocnik",
            "ME" => "bc-3-rocnik",
            "MIS/MSI" => "ing-1-2-rocnik",
            "MA" => "bc-1-rocnik",
            "MIP" => "bc-1-rocnik",
            "MSOFT" => "bc-3-rocnik",
            "OS" => "bc-2-rocnik",
            "ODS" => "bc-2-rocnik",
            "PARALPR" => "ing-1-2-rocnik",
            "PDT" => "ing-1-2-rocnik",
            "PIKT" => "bc-2-rocnik",
            "PSIP" => "bc-3-rocnik",
            "PKOMS" => "bc-2-rocnik",
            "PPI" => "bc-1-rocnik",
            "PPGSO" => "ing-1-2-rocnik",
            "PRPR" => "bc-1-rocnik",
            "SJ" => "ing-1-2-rocnik",
            "SOGAM" => "ing-1-2-rocnik",
            "STROJUC" => "ing-1-2-rocnik",
            "TZI" => "bc-2-rocnik",
            "TSDS" => "ing-1-2-rocnik",
            "TP" => "ing-1-2-rocnik",
            "UMZI" => "4bc-1-rocnik",
            "VNOS" => "ing-1-2-rocnik",
            "VINF" => "ing-1-2-rocnik",
            "ZMTMO" => "4bc-1-rocnik",
            "ZKGRA" => "ing-1-2-rocnik",
            "ZOOP" => "bc-1-rocnik",
            "ZPRPR" => "4bc-1-rocnik"
        },
        "2015-16" => {
            "ALG" => "ing-1-2-rocnik",
            "AASS" => "ing-1-2-rocnik",
            "ASEMBL" => "bc-2-rocnik",
            "BVI" => "ing-1-2-rocnik",
            "DBS" => "bc-2-rocnik",
            "DPRS" => "ing-1-2-rocnik",
            "EA" => "ing-1-2-rocnik",
            "FMAN" => "ing-1-2-rocnik",
            "FLP" => "bc-2-rocnik",
            "FYZ" => "bc-1-rocnik",
            "GRA" => "ing-1-2-rocnik",
            "KDK" => "bc-3-rocnik",
            "KPAIS" => "ing-1-2-rocnik",
            "MSS" => "bc-3-rocnik",
            "ML1" => "bc-1-rocnik",
            "NDS" => "ing-1-2-rocnik",
            "OZNAL" => "ing-1-2-rocnik",
            "OOANS" => "ing-1-2-rocnik",
            "OOP" => "bc-1-rocnik",
            "PKS" => "bc-2-rocnik",
            "PVID" => "ing-1-2-rocnik",
            "PAM" => "bc-1-rocnik",
            "PAS" => "bc-1-rocnik",
            "PIS" => "bc-3-rocnik",
            "PSI" => "bc-2-rocnik",
            "PSFYZ" => "bc-1-rocnik",
            "PAP" => "bc-2-rocnik",
            "RETOR" => "ing-1-2-rocnik",
            "SSIIT" => "ing-1-2-rocnik",
            "SIPVS" => "ing-1-2-rocnik",
            "STOCHM" => "ing-1-2-rocnik",
            "TEAP" => "bc-2-rocnik",
            "UI" => "bc-2-rocnik",
            "UMA" => "4bc-1-rocnik",
            "VPT" => "ing-1-2-rocnik",
            "VD" => "ing-1-2-rocnik",
            "VCMA" => "bc-1-rocnik",
            "VAVA" => "bc-2-rocnik",
            "WANT" => "ing-1-2-rocnik",
            "ZPS" => "4bc-1-rocnik",
            "ZPRPR2" => "4bc-1-rocnik",
            "ZTIAPL" => "4bc-1-rocnik",
            "ADM" => "bc-1-rocnik",
            "AZA" => "bc-2-rocnik",
            "AJ" => "bc-1-rocnik",
            "AIS" => "ing-1-2-rocnik",
            "ASS" => "ing-1-2-rocnik",
            "AOVS" => "ing-1-2-rocnik",
            "BP" => "bc-3-rocnik",
            "BMIS" => "ing-1-2-rocnik",
            "DSA" => "bc-2-rocnik",
            "DD" => "ing-1-2-rocnik",
            "DP" => "ing-1-2-rocnik",
            "ELN" => "bc-2-rocnik",
            "IVZDEL" => "4bc-1-rocnik",
            "ICP" => "bc-3-rocnik",
            "KOD" => "ing-1-2-rocnik",
            "KSS" => "ing-1-2-rocnik",
            "ME" => "bc-3-rocnik",
            "MIS/MSI" => "ing-1-2-rocnik",
            "MA" => "bc-1-rocnik",
            "MIP" => "bc-1-rocnik",
            "MSOFT" => "bc-3-rocnik",
            "OS" => "bc-2-rocnik",
            "PARALPR" => "ing-1-2-rocnik",
            "PDT" => "ing-1-2-rocnik",
            "PIKT" => "bc-2-rocnik",
            "PSIP" => "bc-3-rocnik",
            "PPI" => "bc-1-rocnik",
            "PPGSO" => "ing-1-2-rocnik",
            "PRPR" => "bc-1-rocnik",
            "SJ" => "ing-1-2-rocnik",
            "SOGAM" => "ing-1-2-rocnik",
            "STROJUC" => "ing-1-2-rocnik",
            "TZI" => "bc-2-rocnik",
            "TP" => "ing-1-2-rocnik",
            "UMZI" => "4bc-1-rocnik",
            "VNOS" => "ing-1-2-rocnik",
            "VINF" => "ing-1-2-rocnik",
            "ZMTMO" => "4bc-1-rocnik",
            "ZKGRA" => "ing-1-2-rocnik",
            "ZOOP" => "bc-1-rocnik",
            "ZPRPR" => "4bc-1-rocnik"
        }
    }


    categories.each do |category|
      puts "Migrating #{category.name}"
      match = category.name.match(/^([A-Z\/]{2,}[1-9]?)\s.\s(.*)$/)
      if match
        puts "\tCategory #{match[1]} with subcategory #{match[2]}"
        years.each do |year|
          puts "\t\tInserting into year #{year.name}"
          if !subjects[year.name]
            puts "\t\tYear not fetched"
            subjects[year.name] = {}
          end
          subject_name = match[1].strip

          if !subjects[year.name][subject_name]
            puts "\t\tSubject not fetched"

            next if subject_grade_mapping[year.name][match[1]].nil?

            subject = Shared::Category.create!({
                                name: match[1].strip,
                                tags: category.tags.first,
                                uuid: category.tags.first,
                                parent_id: year.children.where(uuid: subject_grade_mapping[year.name][match[1]]).first.id,
                            })

            subjects[year.name][subject_name] = subject
          end

          puts "\tSaving"
          Shared::Category.create!({
                               name: match[2].strip,
                               tags: category.tags.last,
                               uuid: category.tags.join("-"),
                               parent_id: subjects[year.name][subject_name].id,
                               questions_count: category.questions_count,
                               slido_username: category.slido_username,
                               slido_event_prefix: category.slido_event_prefix
                           })
          puts "\tDone"
        end
      else
        puts
        years.each do |year|
          subject_name = category.name.strip
          uuid = subject_grade_mapping[year.name][subject_name].nil? ? "vseobecne" : subject_grade_mapping[year.name][subject_name]

          Shared::Category.create!({
                               name: category.name,
                               tags: category.tags,
                               uuid: category.tags.join("-"),
                               parent_id: year.children.where(uuid: uuid).first.id,
                               questions_count: category.questions_count,
                               slido_username: category.slido_username,
                               slido_event_prefix: category.slido_event_prefix
                           })
        end
      end
    end
    Shared::Category.rebuild!
  end

  def down
    root = Shared::Category.roots.find_by name: 'root'
    root.children.each do |year|
      year.children.delete_all
    end
  end
end