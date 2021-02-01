class Dewey < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

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
