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
  # using lower case in order to find all sort of queries
  scope :with_name, ->(name) { where('LOWER(name) like ?', "%#{name.downcase}%") }

  # with_phone allows searching from the some part of the phone number
  # if it doesn't needed - need to remove the first % from the search and create an index
  scope :with_phone, ->(phone) { where('phone like ?', "%#{phone}%") }
  scope :after_id, ->(id) { where('id > ', id) }
  scope :of_age, ->(age) {
    where('birthday >= ? AND birthday < ?',
      (age+1).years.ago.to_date,
      (age).years.ago.to_date
    ) }

#-- public methods --#
  # @return person's age
  def age
    Date.today.year - birthday.year
  end

  # @return person's address
  # assumes all [street, city, country] is not nil
  # if that can't be assumed, this method should return other text
  def address
    "#{street} #{city}, #{country}."
  end
end
