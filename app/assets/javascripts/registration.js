// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  var updateCrop = function(coords) {
    $('#member_crop_x').val(coords.x);
    $('#member_crop_y').val(coords.y);
    $('#member_crop_w').val(coords.w);
    $('#member_crop_h').val(coords.h);
  }

  $('body.registration-photo #crop-image').Jcrop({
    setSelect: [25, 25, 500, 500],
    aspectRatio: 350/450,
    onChange: updateCrop,
    onSelect: updateCrop
  });
})