// Code to control the showing and hiding of the new venue form
$(document).ready(function() {

  var hidden_field_selector = "#venue .nested-fields [name*=create_venue]"

  if ($(hidden_field_selector).length) {
    toggle_new_venue();
  } else {
    toggle_select_venue();
  }

  $('#venue .js-new-venue').click(
    function() { toggle_new_venue(); }
  );
  $('#venue .js-cancel-new-venue').click(
    function() { toggle_select_venue(); }
  );


  function reset_venue_fields() {
    $("#venue .nested-fields :input").val(''); // reset venue fields
  }

  function reset_venue_select() {
    $("#venue select").select2('val', '')
    $("#venue select").removeAttr('selected')
  }

  function add_hidden_field() {
    var $hiddenInput = $('<input/>', { type:'hidden', name:'event_form[create_venue]', value:'true' });
    $hiddenInput.appendTo("#venue .nested-fields");
  }
  function remove_hidden_field() {
    $(hidden_field_selector).remove();
  }

  function toggle_new_venue() {
    reset_venue_select();
    add_hidden_field();
    $("#venue .nested-fields").show();
    $("#venue .select").hide();
  }

  function toggle_select_venue() {
    reset_venue_fields();
    remove_hidden_field();
    $("#venue .nested-fields").hide();
    $("#venue .select").show();
  }
});
