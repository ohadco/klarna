Rails.application.routes.draw do

  # root of the app
  root 'peoples#index'

  # shows the main search page
  get 'peoples/index'

  # pull and update the list of people
  get 'peoples/search'

end
