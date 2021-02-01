class Cutter < ApplicationRecord
  validates :num, presence: true
  validates :str, presence: true, uniqueness: true

  def self.cut(s)
    if s.blank?
      return ""
    else
      s = s.gsub(/ü/, 'u')
      s = s.gsub(/ė/, 'e')
      s = s.gsub(/ę/, 'e')
      s = I18n.transliterate(s.gsub(/[^a-zA-Z,\.]/i,'').downcase)
      hits = []
      i = 0
      while i < (s.length-1) && hits.size != 1 
        i = i + 1
        check = where("str LIKE ?", "#{s[0..i]}%")
        if check.empty?
          break
        else    
          hits = check
        end    
      end
      #  see if exact match
      if hits.count > 1
        if where("str LIKE ?", "#{s[0..i]}").empty?
          i = i - 1
          hits = where("str LIKE ?", "#{s[0..i]}%")
        end
      elsif hits.empty?
        hits = [where(["str < ?", s]).last]
      end
      return s[0].upcase + hits.first.num.to_s.gsub(/0*$/, '')
    end
  end
  
end
