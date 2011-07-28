// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  if (!$('body').hasClass('registration-photo')) return;

  var previewImg = $('#crop-preview img');
  var largeImg = $('#crop-image');

  var updateCrop = function(coords) {
    var rx = previewImg.parent().width() / coords.w;
    var ry = previewImg.parent().height() / coords.h;
    previewImg.css({
      width: Math.round(rx * largeImg.width()) + 'px',
      height: Math.round(ry * largeImg.height()) + 'px',
      marginLeft: '-' + Math.round(rx * coords.x) + 'px',
      marginTop: '-' + Math.round(ry * coords.y) + 'px'
    });

    $('#member_crop_x').val(coords.x);
    $('#member_crop_y').val(coords.y);
    $('#member_crop_w').val(coords.w);
    $('#member_crop_h').val(coords.h);
  }

  var aspectRatio = 350/450;
  var initial = {
    x: Number($('#member_crop_x').val()), y: Number($('#member_crop_y').val()),
    w: Number($('#member_crop_w').val()), h: Number($('#member_crop_h').val())
  }
  if(initial.w == 0 || initial.h == 0) {
    initial = { x: 50, y: 10, w: 315, h: 405 };
  }

  $('body.registration-photo #crop-image').Jcrop({
    setSelect: [initial.x, initial.y, initial.x + initial.w, initial.y + initial.h],
    aspectRatio: aspectRatio,
    onChange: updateCrop,
    onSelect: updateCrop
  });
})