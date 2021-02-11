class Dewey < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true


  def parent
     stripz = code.to_s.gsub(/0*$/, '')
     if stripz.gsub(/\.$/, '') =~ /\./
      places = code.to_s.split(/\./).last.size
     else
      places = 0
     end
     if places == 0
      
      if sprintf("%03d", code)[2] == '0'
        if sprintf("%03d", code)[1] == '0'
          return nil
        else
          return (sprintf("%03d", code)[0] + "00").to_f
        end
      else

        return (sprintf("%03d", code)[0..1] + "0").to_f
      end
     else

      return stripz[0...-1].to_f
     end
  end
  
  def name_with_ancestry(trail = '')
    if parent == code || parent.nil?
      return trail.gsub(/>>\s$/, '').strip
    else
      return Dewey.find_by(code: parent).name_with_ancestry(name + " >> " + trail)
    end
  end
  
  def self.tree_limit(num)
    precision = [10, 1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0.000000001, 0.0000000001]
    if num.to_i.to_s == num.to_s
      places = -1
    else
      places = num.to_s =~ /\.0$/ ? 0 : num.to_s.gsub(/0*$/, '').split('.').last.size
    end
    Rails.logger.error num.class.to_s
    Rails.logger.error precision.class.to_s
    Rails.logger.error places.class.to_s
    return (num.to_f + precision[places+1].to_f).to_f.round(places).to_f
  end

  def self.import(json, parent = nil)
    json.each do |record|
      if record["id"] =~ /xx$/
        Dewey.import(record["subordinates"], record["description"])
      else
        # next unless record["number"] =~ /^[\d\/.]*$/
        if parent && record["description"]
          create(code: record["number"], name: parent + ' - ' + record["description"])
        else
          create(code: record["number"], name: record["description"])
        end
        if record["subordinates"]
          unless record["subordinates"].empty?
            Dewey.import(record["subordinates"])
          end
        end
      end
    end
  end 
end
