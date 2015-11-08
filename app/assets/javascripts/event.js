// Code to control the cocoon-powered insertion of adding new venue fields
$(document).ready(function() {
  $("#venue a.add_fields").
    data("association-insertion-position", 'after').
    data("association-insertion-node", 'this');

  $('#venue').bind('cocoon:before-insert',
    function() {
      $("#venue label").hide();
      $("#venue .select2-container").hide();
      $("#venue a.add_fields").hide();
    });
  $('#venue').bind("cocoon:after-remove",
    function() {
      $("#venue label").show();
      $("#venue .select2-container").show();
      $("#venue a.add_fields").show();
    });
});
