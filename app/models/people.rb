class People < ActiveRecord::Base

#-- validations --#

  # validates that that the records are not duplicated
  validates_uniqueness_of :uid

#-- scopes --#
  scope :with_name, ->(name) { where('name like ?', "%#{name}%") }
  scope :with_phone, ->(phone) { where('phone like ?', "%#{phone}%") }
  scope :of_age, ->(age) {
    where('birthday >= ? AND birthday < ?',
    (age+1).years.ago.to_date,
    (age).years.ago.to_date
        ) }

#-- methods --#

  # returns person's age
  def age
    Date.today.year - birthday.year
  end

  # returns person's address
  def address
    "#{street} #{city}, #{country}."
  end
end
