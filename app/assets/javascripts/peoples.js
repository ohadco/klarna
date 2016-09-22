
// GET peoples/search using ajax - expect js code as response
function searchPeople() {

  /**
  * collecting the data for the request.
  * terms will contain the search query
  */
  var terms;
  terms = $('#search_people_input').val();

  /**
  * the ajax request itself
  * will run the js response
  * the response contains the code for updating the view
  */
  $.ajax({
    type: 'GET',
    url: '/peoples/search.js',
    data: "search_terms=" + terms
  });
};

// functions to run after page loads:
$(document).ready(function() {

  // listener for the input - calls searchPeople function
  $('#search_people_input').on('change keyup', searchPeople);

  // clear the input field on page load (actually this is for a refresh)
  $('#search_people_input').val('');
});
