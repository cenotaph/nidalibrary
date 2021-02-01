class Book < ApplicationRecord
  belongs_to :section, optional: true
  belongs_to :status
  has_many :books_fasts
  has_many :fasts, through: :books_fasts
  
  validates :call_number, uniqueness: true, allow_blank: true
  validates_presence_of :title #, :catno
  
  def sort_title
    return title.gsub(/^(?:(la|le|les|die|das|der|the|a|an) +)|(?:(l'|d'))/i, '')
  end
  
  extend FriendlyId
  friendly_id :title, use: [:slugged]
  mount_uploader :image, BookimageUploader
  before_save :update_image_attributes
  
  def self.clean_partnerships(term)
    term.split(/(\s*\/\s*)|(\s*\&\s)|(,\s*)|(\s+and\s+)|(\s+ir\s+)/).delete_if{|x| x =~ /^(\s*\/\s*)|(\s*\&\s*)|(,\s*)|(\s+and\s+)|(\s+ir\s+)$/ }.map{|x| x.split.last + ', ' + x.split.first(x.split.size - 1).join(' ') }.join('; ')
  end

  def suggested_call_number
    if author.blank? #|| author =~ /editor/i || author =~ /ed\./
      base = ddc.to_s.gsub(/\.0$/, '') + ' ' + sort_title.gsub(/\s/, '').gsub(/\W/, '')[0].upcase + sort_title.gsub(/\s/, '').gsub(/\W/, '')[1].downcase
    else
      base = ddc.to_s.gsub(/\.0$/, '') + ' ' + Cutter.cut(author)
      others_in_class = Book.where(ddc: ddc).where("id <> ?", id).where('author is not null')
      cut = Cutter.cut(author)
      if others_in_class.map{|x| Cutter.cut(x.author) }.include?(cut)
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
    return base

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
