class PeoplesController < ApplicationController
  def index
  end

  # accept's only js request for updating the list of people
  def search

    # extract the terms from params
    terms = params[:search_terms]

    # redirect to root in case of missing terms
    redirect_to root_path and return if terms.blank?

    # extract the terms to an array
    # delete('-') because phones are saved without '-' (numbers only)
    terms_array = params[:search_terms].delete('-').split(' ')

    # extract the params using private methods
    age = age_param(terms_array)
    phone = phone_param(terms_array)
    names_array = name_param_array(terms)

    # add scopes only if the specific terms exists
    @peoples = People.order(:id)
    @peoples = @peoples.with_phone(phone) if phone.present?
    @peoples = @peoples.of_age(age) if age.present?

    # this allows searching names from any place in the query:
    # for an example "smith 33 jons dr." will be able to find "Dr. John Smith"
    if names_array.size > 0
      names_array.each do |name|
        @peoples = @peoples.with_name(name)
      end
    end

    # [TODO] - the next comment line will allow "show more" logic
    # @peoples = @peoples.after_id(params[:after_id]) if params[:after_id].present?

    # limits the amount of people to show in the query
    @peoples = @peoples.limit(People::MAX_AMOUNT_TO_SHOW)

    # renders 'search.js'
  end

private

  # returns the first term that will match the age pattern
  # assuming age is between 1 to 120
  def age_param (terms_array)
    terms_array.each do |term|
      return term.to_i if term.to_i.between?(1,120)
    end
    return nil
  end

  # returns the first term that will match the phone pattern
  def phone_param (terms_array)
    terms_array.each do |term|
      return term if term.to_i>120
    end
    return nil
  end
  def name_param_array (terms)

    # extract all char, dot, spaces from the string
    # "squish" the string (leaves only one space in case of multiple spaces)
    # this also allows using "John 33 smith" as search term - will return "john smith"
    terms.scan(/[[:alpha:]]|\.|[[:space:]]/).join.squish.split(' ')
  end
end
