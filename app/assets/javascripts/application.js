// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require select2
//= require foundation
//= require pickadate/picker
//= require pickadate/picker.date
//= require pickadate/legacy
//= require jquery.sieve
//= require cocoon

//= require_tree .

$(function(){ $(document).foundation(); });

// Add a datepicker to all date fields:
$("input.date").pickadate();

// Add a search box to all select fields:
$("select").select2();

// Sieve items in lists:
$(document).ready(function() {
  $("ul.sieve").sieve({ itemSelector: "li" });
});

$(window).on("load resize", function(){
  height = Math.max($('.inner-wrap').height(), $(this).height());
  $('.left-off-canvas-menu').height(height);
  $('.main-section').height(height);
});