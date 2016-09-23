class People < ActiveRecord::Base
  # MAX_AMOUNT_TO_SHOW configures the maximum..
  # ..amount of people to show in each batch
  MAX_AMOUNT_TO_SHOW = 100

  #-- validations --#
  # validates that the imported records are not duplicated
  # if we will use more than one data source for import - we..
  # ..might need to remove this validation
  validates_uniqueness_of :uid

  #-- scopes --#
  default_scope { order(:id) }
  # using lower case in order to find all sort of queries
  scope :with_name, ->(name) { where('LOWER(name) like ?', "%#{name.downcase}%") }

  # with_phone allows searching from the some part of the phone number
  # if it doesn't needed - need to remove the first % from the search and /
  # create an index
  scope :with_phone, ->(phone) { where('phone like ?', "%#{phone}%") }
  # scope :after_id, ->(id) { where('id > ', id) }
  scope :of_age, ->(age) {
    where(
      'birthday >= ? AND birthday < ?',
      (age + 1).years.ago.to_date,
      age.years.ago.to_date
    )
  }
  #-- advanced scopes --#
  def self.search_by_terms(names_array, phone, age)
    peoples = self
    peoples = peoples.with_phone(phone) if phone.present?
    peoples = peoples.of_age(age) if age.present?

    # this allows searching names from any place in the query:
    # for an example "smith 33 jons dr." will be able to find "Dr. John Smith"
    unless names_array.empty?
      names_array.each do |name|
        peoples = peoples.with_name(name)
      end
    end
    peoples.limit(MAX_AMOUNT_TO_SHOW)
  end

  #-- public methods --#
  # @return person's age
  def age
    today = Date.today
    age = today.year - birthday.year
    age -= 1 if today.yday < birthday.yday
    age
  end

  # @return person's address
  # assumes all [street, city, country] is not nil
  # if that can't be assumed, this method should return other text
  def address
    "#{street} #{city}, #{country}."
  end
end
