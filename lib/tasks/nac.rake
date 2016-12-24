namespace :nac do
  desc 'import csv to database'
  task import_csv: :environment do

    require 'csv'    

    csv_text = File.read('/Users/fail/Desktop/nida.csv')
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      next if row[3].blank? && row[7].blank?
      book = Book.create(isbn13: row[0], title: row[2], language: row[3], publisher: row[4], pages: row[5], year_published: row[6], author: row[7], subtitle: row[8], comment: row[9], catno: row[10], provenance: row[11])
      p 'book is ' + book.title
    end
  
  
  end
  
  task fix_isbn: :environment do
    Book.all.each do |book|
      if book.isbn13 !~ /^978/
        book.isbn10 = book.isbn13
        book.isbn13 = nil
        book.save!
      end
    end
  end
  
  task assign_sections: :environment do
    Book.where(section: nil).each do |book|
      s = book.catno.strip.split(',').first.gsub(/\d*$/, '')
      case s
      when 'LOC'
        book.section = Section.friendly.find('location')
      when 'NACR'
        book.section = Section.friendly.find('nida-residents')
      when 'AV'
        book.section = Section.friendly.find('audio-visual')
      when 'GNO'
        book.section = Section.friendly.find('graphic-novels')
      when 'FM'
        book.section = Section.friendly.find('film-and-music')
      when 'LPST'
        book.section = Section.friendly.find('land-place-site-tourism')
      when 'FSUS'
        book.section = Section.friendly.find('food-sustainability-nature')
      when 'TH'
        book.section = Section.friendly.find('theory')
      when 'ARC'
        book.section = Section.friendly.find('architecture')
      when 'MON'
        book.section = Section.friendly.find('monographs')                        
      when 'FIC'
        book.section = Section.friendly.find('fiction-and-literature')  
      when 'CAT'
        book.section = Section.friendly.find('catalogues')  
      when 'LT'
        book.section = Section.friendly.find('lithuania')
      when 'LT.MP'
        book.section = Section.friendly.find('lithuanian-media-and-photography')
      when 'VDA'
        book.section = Section.friendly.find('vaa-publications')
      when 'DES'
        book.section = Section.friendly.find('design')
      when 'COMPT'
        book.section = Section.friendly.find('community-and-participatory-art')
      when 'LT.A'
        book.section = Section.friendly.find('lithuanian-art')
      when 'EDU'
        book.section = Section.friendly.find('education')   
      when 'CUR'
        book.section = Section.friendly.find('curation')                   
      when 'MISC'
        book.section = Section.friendly.find('miscellaneous')
      when 'RES'
        book.section = Section.friendly.find('residencies')
      when 'LV.A'
        book.section = Section.friendly.find('latvian-art')
      when 'E.EUR'
        book.section = Section.friendly.find('eastern-europe')
      else
        p 'error, cat no is ' + book.catno
      end
      book.save!
    end
  end
  
  task get_duplicates: :environment do
    Book.where(section: nil).each do |book|
      splits = book.catno.split(/\s/)
      if splits.size > 1
        book.catno = splits[0]
        book.save
        for i in 1..(splits.size-1)
          newbook = book.dup
          newbook.catno = splits[i]
          newbook.save
        end
      end
    end
  end
  task get_amazon_images: :environment do
  
    Book.where(image: nil).each do |book|
      unless book.isbn10.blank?
        begin
          as = Amazon::Ecs.item_lookup(book.isbn10.gsub(/\D/, ''), search_index: 'Books', IdType: 'ISBN', :response_group => 'Medium').items
          if as[0]
            book.summary = as[0].get('EditorialReviews/EditorialReview/Content')
            book.remote_image_url = as[0].get_hash('LargeImage')['URL']
            p 'saving ' + book.remote_image_url + ' for book ' + book.title
            book.save!
          else
            p 'no match for ' + book.title
          end
        rescue 
          puts "can't get stuff: "
        end  
      end
    end
  end
  
  
end