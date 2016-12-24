class CreateSections < ActiveRecord::Migration[5.0]
  def self.up
    create_table :sections do |t|
      t.string :name
      t.string :colour, limit: 7
      t.string :slug

      t.timestamps
    end
    Section.create(name: 'Location')
    Section.create(name: 'Lithuania')
    Section.create(name: 'Lithuanian media and photography')
    Section.create(name: 'Lithuanian art')
    Section.create(name: 'VAA Publications')
    Section.create(name: 'Monographs')
    Section.create(name: 'Eastern Europe')
    Section.create(name: 'Latvian Art')
    Section.create(name: 'Education')
    Section.create(name: 'Curation')
    Section.create(name: 'Residencies')
    Section.create(name: 'Architecture')
    Section.create(name: 'Design')
    Section.create(name: 'Theory')
    Section.create(name: 'Food / Sustainability / Nature')
    Section.create(name: 'Land / Place / Site / Tourism')
    Section.create(name: 'Community and Participatory Art')
    Section.create(name: 'Graphic Novels')
    Section.create(name: 'Film and Music')
    Section.create(name: 'Catalogues')
    Section.create(name: 'Fiction and Literature')
    Section.create(name: 'Miscellaneous')
    Section.create(name: 'Audio-Visual')
    Section.create(name: 'Nida Residents')
  end
  
  def self.down
    drop_table :sections
  end
end
