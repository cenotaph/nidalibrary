class Book < ApplicationRecord
  belongs_to :section, optional: true
  belongs_to :collection, optional: true
  belongs_to :status
  has_many :books_fasts, dependent: :destroy
  has_many :fasts, through: :books_fasts
  
  validates_uniqueness_of :call_number , allow_nil: true
  validates_presence_of :title #, :catno
  attr_accessor :reset_callno
  before_validation :update_call_number
  
  def sort_title
    return title.gsub(/^(?:(la|le|les|die|das|der|the|a|an) +)|(?:(l'|d'))/i, '')
  end
  
  extend FriendlyId
  friendly_id :title, use: [:slugged]
  mount_uploader :image, BookimageUploader
  before_save :update_image_attributes
  
  def update_call_number
    if reset_callno || (changed.include?("ddc") && (call_number.blank? || call_number == 'null'))
      self.call_number = self.suggested_call_number
    end
  end

  def generate_new_call_number
    self.call_number = self.suggested_call_number
  end

  def name_to_cut
    if !artist.blank?
      return artist
    elsif author_is_institution && publisher != author
      return publisher
    else
      return author
    end    
  end
  
  def self.clean_partnerships(term)
    term.split(/(\s*\/\s*)|(\s*\&\s)|(,\s*)|(\s+and\s+)|(\s+ir\s+)/).delete_if{|x| x =~ /^(\s*\/\s*)|(\s*\&\s*)|(,\s*)|(\s+and\s+)|(\s+ir\s+)$/ }.map{|x| x.split.last + ', ' + x.split.first(x.split.size - 1).join(' ') }.join('; ')
  end

  def suggested_call_number
    if ddc.blank?
      return nil
    else
      if name_to_cut.blank? 
        base = ddc.to_s.gsub(/\.0$/, '') + ' ' + sort_title.gsub(/\s/, '').gsub(/\W/, '')[0].upcase + sort_title.gsub(/\s/, '').gsub(/\W/, '')[1].downcase + ' ' + year_published.to_s
      else
        cut = Cutter.cut(name_to_cut)
        base = ddc.to_s.gsub(/\.0$/, '') + ' ' + cut # + ' ' + year_published.to_s
        
        if Book.unscoped.exists?(["id <> ? AND (call_number = ? OR call_number LIKE ?)", id, base, base + ' '  + year_published.to_s + '%'])
          oics = Book.where(["id <> ? AND (call_number = ? OR call_number LIKE ?)", id, base, base + ' '  + year_published.to_s + '%'])
          oics.each do |oic|
            if oics.where(["id <> ?", oic.id]).map(&:year_published).include?(oic.year_published)
              start = oics.sort_by(&:year_published).index(oic) + 1
              cn = oic.ddc.to_s.gsub(/\.0$/, '') + ' ' + Cutter.cut(oic.name_to_cut) + ' ' + oic.year_published.to_s + '.' + start.to_s
              if Book.unscoped.exists?(["id <> ? AND call_number = ?", id, cn])
                loop do
                  start = start + 1
                  cn.gsub!(/\.\d$/, '.' + start.to_s)
                  break cn unless  Book.unscoped.exists?(["id <> ? AND call_number = ?", id, cn])
                end
              end
              oic.call_number = cn
              oic.save!
            else
              # only one other by this year so add a #
              
              # puts 'oics: ' + oics.inspect
              puts 'this oic: ' + oic.id.to_s + '; cn: ' + oic.call_number + '.' + (oics.index(oic) + 1).to_s
              start = oics.index(oic) + 1
              new_call_number = oic.ddc.to_s.gsub(/\.0$/, '') + ' ' + Cutter.cut(oic.name_to_cut) + ' ' + oic.year_published.to_s + '.' + start.to_s
              
              if Book.unscoped.exists?(["id <> ? AND call_number = ?", id, new_call_number])
                loop do
                  start = start + 1
                  new_call_number.gsub!(/\.\d$/, '.' + start.to_s)
                  break new_call_number unless  Book.unscoped.exists?(["id <> ? AND call_number = ?", id, new_call_number])
                end
              else
                puts 'self: ' + self.inspect
                puts 'oic: ' + oic.id.to_s
                puts new_call_number
                
              end
              oic.call_number = new_call_number
              
              # oic.call_number = oic.call_number + ' ' + oic.year_published.to_s
              oic.save!
              puts ' changed oic ' + oic.id.to_s + ' to '  + oic.call_number
            end
          end
          base = base + ' '  + year_published.to_s 
        end
        # changed others to have year
        if Book.unscoped.exists?(["id <> ? AND call_number = ?", id, base])
          i = 2
          base = base + "."
          loop do
            base = base + i.to_s
            break base unless  Book.unscoped.exists?(["id <> ? AND call_number = ?", id, base])
            i = i + 1
          end
        end
              # sames = others_in_class.reject{|x| x.name_to_cut != name_to_cut }
      end
      if base =~ /\./
        if base.split(/\./)[0].length == 2
          return "0" + base.strip
        elsif base.split(/\./)[0].length == 1
          return "00" + base.strip
        else
          return base.strip
        end
      else
        return base.strip
      end
    end

  end
  
  def suggested_call_number_old
    if ddc.blank?
      return nil
    else
      if name_to_cut.blank? 
        base = ddc.to_s.gsub(/\.0$/, '') + ' ' + sort_title.gsub(/\s/, '').gsub(/\W/, '')[0].upcase + sort_title.gsub(/\s/, '').gsub(/\W/, '')[1].downcase
      else
        base = ddc.to_s.gsub(/\.0$/, '') + ' ' + Cutter.cut(name_to_cut)
        if new_record?
          others_in_class = Book.where(ddc: ddc).where('author is not null')
        else
          others_in_class = Book.where(ddc: ddc).where("id <> ?", id).where('author is not null')
        end
        cut = Cutter.cut(name_to_cut)
        if others_in_class.map{|x| Cutter.cut(x.name_to_cut) }.include?(cut)
          base = base + ' ' + sort_title.gsub(/\s/, '').gsub(/\W/, '')[0].upcase + sort_title.gsub(/\s/, '').gsub(/\W/, '')[1].downcase
          i = 2
          loop do
            if sort_title.gsub(/\s/, '').gsub(/\W/, '')[i].nil?
              base = base + i.to_s
            else
              base = base + sort_title.gsub(/\s/, '').gsub(/\W/, '')[i].downcase
            end
            break base unless Book.unscoped.exists?(["id <> ? AND call_number = ?", id, base])
            i = i + 1
          end
        end
      end
      if base =~ /\./
        if base.split(/\./)[0].length == 2
          return "0" + base
        elsif base.split(/\./)[0].length == 1
          return "00" + base
        else
          return base
        end
      else
        return base
      end
    end

  end
  

  def get_by_oclc(oclc) 
    conn = Faraday.new(url: 'http://classify.oclc.org/classify2',
      headers: {'Content-Type' => 'application/json'})
    resp = conn.get('Classify') do |req|
      req.params['wi'] = oclc
      req.params['summary'] = true
    end

    if resp.status == 200
      doc = Nokogiri::XML(resp.body)
      unless doc.css('recommendations/ddc/mostPopular').empty?
        self.ddc = doc.css('recommendations/ddc/mostPopular').first["nsfa"]
        self.ddc_count = doc.css('recommendations/ddc/mostPopular').first["holdings"]
      end
      unless doc.css('recommendations/lcc/mostPopular').empty?
        self.lcc = doc.css('recommendations/lcc/mostPopular').first["nsfa"]
        self.lcc_count = doc.css('recommendations/lcc/mostPopular').first["holdings"]
      end
      if doc.css('classify/work').empty?
        sco = 'classify/works/work' unless doc.css('classify/works/work').empty?
      else
        sco = 'classify/work'
      end
      if doc.css(sco)[0]["wi"].nil?
        self.oclc = doc.css(sco)[0].text rescue nil
      else
        self.oclc = doc.css(sco)[0]["wi"]
      end

      # fix titles and authors
      if doc.css('classify/work')[0]['author'].nil?
        unless doc.css('classify/works/work').map{|x| x['author'] }.compact.empty?
          self.author = doc.css('classify/works/work').map{|x| x['author'] }.min
        end
      else
        self.author = doc.css('classify/work')[0]['author']
      end
      if doc.css('classify/work')[0]['title'].nil?
        unless doc.css('classify/works/work').map{|x| x['title'] }.compact.empty?
          self.author = doc.css('classify/works/work').map{|x| x['title'] }.max
        end
      else
        self.title = doc.css('classify/work')[0]['title']
      end
      doc.css('recommendations/fast/headings/heading').each do |fh|
        fast_heading = Fast.find_or_create_by(code: fh["ident"], name: fh.text)
        fasts << fast_heading
      end
    end
  end

  def self.search_isbn(isbn13)
    conn = Faraday.new(url: 'http://classify.oclc.org/classify2',
      headers: {'Content-Type' => 'application/json'})
    resp = conn.get('Classify') do |req|
      req.params['isbn'] = isbn13.gsub(/\D/, '')
    end
    potential_book = Book.new
    if resp.status == 200
      doc = Nokogiri::XML(resp.body)

      if doc.css('response')[0]['code'] == "102"
        return false
      # elsif  doc.css('response')[0]['code'] == "101"
      #   isbn10 = nil
      #   isbn13 = nil
      #   classify(true)
      else
        if doc.css('workCount').empty?    # only one record
          unless doc.css('recommendations/ddc/mostPopular').empty?
            potential_book.ddc = doc.css('recommendations/ddc/mostPopular').first["nsfa"]
            potential_book.ddc_count = doc.css('recommendations/ddc/mostPopular').first["holdings"]
          end
          unless doc.css('recommendations/lcc/mostPopular').empty?
            potential_book.lcc = doc.css('recommendations/lcc/mostPopular').first["nsfa"]
            potential_book.lcc_count = doc.css('recommendations/lcc/mostPopular').first["holdings"]
          end
          if doc.css('classify/work').empty?
            sco = 'classify/works/work' unless doc.css('classify/works/work').empty?
          else
            sco = 'classify/work'
          end
          if doc.css(sco)[0]
            if doc.css(sco)[0]["wi"].nil?
              potential_book.oclc = doc.css(sco)[0].text rescue nil
            else
              potential_book.oclc = doc.css(sco)[0]["wi"]
            end
          end
    
          # fix titles and authors
          if doc.css('classify/work')[0]
            if doc.css('classify/work')[0]['author'].nil?
              unless doc.css('classify/works/work').map{|x| x['author'] }.compact.empty?
                potential_book.author = doc.css('classify/works/work').map{|x| x['author'] }.min
              end
            else
              potential_book.author = doc.css('classify/work')[0]['author']
            end
            if doc.css('classify/work')[0]['title'].nil?
              unless doc.css('classify/works/work').map{|x| x['title'] }.compact.empty?
                potential_book.author = doc.css('classify/works/work').map{|x| x['title'] }.max
              end
            else
              potential_book.title = doc.css('classify/work')[0]['title']
            end
          end
          # doc.css('recommendations/fast/headings/heading').each do |fh|
          #   fast_heading = Fast.find_or_create_by(code: fh["ident"], name: fh.text)
          #   potential_book.fasts << fast_heading unless potential_bookfasts.include?(fast_heading)
          # end
        else
          lookup = nil
          doc.css('works/work').each do |work|

            if work['schemes'] =~ /DDC/ && work['schemes'] =~ /LCC/
              lookup = work['wi']
            elsif lookup.nil? && work['schemes'] =~ /DDC/ && work['schemes'] !~ /LCC/     # then just dewey
              lookup = work['wi']
            elsif lookup.nil? && work['schemes'] =~ /LCC/ && work['schemes'] !~ /DDC/    # then just LCC
              lookup = work['wi']
            end
          end
          if lookup.nil?    # then whatever is first
            lookup = doc.css('works/work')[0]['wi']
            if lookup.nil?
              lookup = doc.css('classift/work/work')[0]['wi']
            end
          end

          # get_by_oclc(lookup)
        end
      end

      return potential_book
    else
      Rails.logger.error 'error retrieving: ' + resp.status.to_s
    end

  end

  def classify(only_title = nil)
    conn = Faraday.new(url: 'http://classify.oclc.org/classify2',
      headers: {'Content-Type' => 'application/json'})

    resp = conn.get('Classify') do |req|
      if (isbn10.blank? && isbn13.blank?) || only_title
        req.params['title'] = title
        req.params['author'] = author.split.first rescue nil
      else
        req.params['isbn'] = isbn13.blank? ? isbn10.gsub(/\D/, '') : isbn13.gsub(/\D/, '')
      end
    end
    if resp.status == 200
      doc = Nokogiri::XML(resp.body)

      if doc.css('response')[0]['code'] == "102"
        self.not_found = true
      elsif  doc.css('response')[0]['code'] == "101"
        isbn10 = nil
        isbn13 = nil
        classify(true)
      else
        if doc.css('workCount').empty?    # only one record
          unless doc.css('recommendations/ddc/mostPopular').empty?
            self.ddc = doc.css('recommendations/ddc/mostPopular').first["nsfa"]
            self.ddc_count = doc.css('recommendations/ddc/mostPopular').first["holdings"]
          end
          unless doc.css('recommendations/lcc/mostPopular').empty?
            self.lcc = doc.css('recommendations/lcc/mostPopular').first["nsfa"]
            self.lcc_count = doc.css('recommendations/lcc/mostPopular').first["holdings"]
          end
          if doc.css('classify/work').empty?
            sco = 'classify/works/work' unless doc.css('classify/works/work').empty?
          else
            sco = 'classify/work'
          end
          if doc.css(sco)[0]
            if doc.css(sco)[0]["wi"].nil?
              self.oclc = doc.css(sco)[0].text rescue nil
            else
              self.oclc = doc.css(sco)[0]["wi"]
            end
          end
    
          # fix titles and authors
          if doc.css('classify/work')[0]
            if doc.css('classify/work')[0]['author'].nil?
              unless doc.css('classify/works/work').map{|x| x['author'] }.compact.empty?
                self.author = doc.css('classify/works/work').map{|x| x['author'] }.min
              end
            else
              self.author = doc.css('classify/work')[0]['author']
            end
            if doc.css('classify/work')[0]['title'].nil?
              unless doc.css('classify/works/work').map{|x| x['title'] }.compact.empty?
                self.author = doc.css('classify/works/work').map{|x| x['title'] }.max
              end
            else
              self.title = doc.css('classify/work')[0]['title']
            end
          end
          doc.css('recommendations/fast/headings/heading').each do |fh|
            fast_heading = Fast.find_or_create_by(code: fh["ident"], name: fh.text)
            fasts << fast_heading unless fasts.include?(fast_heading)
          end
        else
          lookup = nil
          doc.css('works/work').each do |work|

            if work['schemes'] =~ /DDC/ && work['schemes'] =~ /LCC/
              lookup = work['wi']
            elsif lookup.nil? && work['schemes'] =~ /DDC/ && work['schemes'] !~ /LCC/     # then just dewey
              lookup = work['wi']
            elsif lookup.nil? && work['schemes'] =~ /LCC/ && work['schemes'] !~ /DDC/    # then just LCC
              lookup = work['wi']
            end
          end
          if lookup.nil?    # then whatever is first
            lookup = doc.css('works/work')[0]['wi']
            if lookup.nil?
              lookup = doc.css('classift/work/work')[0]['wi']
            end
          end

          get_by_oclc(lookup)
        end
      end
      Rails.logger.error self.inspect
      return save!
    else
      Rails.logger.error 'error retrieving: ' + resp.status.to_s
    end

  end
  
  private
  
  def update_image_attributes
    if image.present? && image_changed?
      if image.file.exists?
        self.image_content_type = image.file.content_type
        self.image_size = image.file.size
        self.image_width, self.image_height = `identify -format "%wx%h" #{image.file.path}`.split(/x/)
      end
    end
  end
end
