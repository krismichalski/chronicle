$(function() {
  $('#players_age_slider').slider();
  return $('a.confirm_alert').on('click', function() {
    return window.confirm("Jesteś pewien?");
  });
});
