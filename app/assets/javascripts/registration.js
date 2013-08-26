// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  if ($('body').hasClass('photo')) {
    initWebcam();
    initCropper();
  }

  // study form widget
  var studyWidget = $('form .study-field select');
  studyWidget.change(function() {
    var enableOther = $('option:selected', this).text() == "Andere"
    var other = $(this).parent().siblings('.study-field-other');
    if(enableOther) { other.show(); $('input', other).attr('disabled', false); }
    else { other.hide(); $('input', other).attr('disabled', true); }
  });

  // make sure that everything is show correctly on page load
  studyWidget.each(function(i, e) {
    var other = $(e).parent().siblings('.study-field-other');
    if($(e).val() != $('input', other).val()) {
      $('option:last', e).attr('selected', true);
    }
  });
  studyWidget.change();
})

function initWebcam() {
  var frozen = false;
  $('#cam-snap').click(function(evt) {
    evt.preventDefault();

    if(!frozen) {
      var base64 = $.scriptcam.getFrameAsBase64();
      $('#member_photo_base64').val(base64);
      $('#cam-preview').attr('src', 'data:image/png;base64,' + base64);
      $('#cam-preview, #cam-mask').show();

      $('#cam-submit').button('enable')
      $(this).val("Nieuwe foto");
    }
    else {
      $('#cam-submit').button('disable');
      $('#cam-preview, #cam-mask').hide();
      $(this).val("Foto nemen");
    }
    frozen = !frozen;
  });

  $('#cam-submit').click(function(evt) {
    evt.preventDefault();

    // dismiss modal window and submit
    $('#dialog:ui-dialog').dialog('destroy');

    $('#member_crop_x').val(0);
    $('#member_crop_y').val(0);
    $('#member_crop_w').val(0);
    $('#member_crop_h').val(0);
    $('#member_photo_base64').parents('form').submit();
  });

  var camOptions = {
    path: '/scriptcam/',
    width: 640, height: 480,
    cornerRadius: 0,
    maskImage: $('#cam-mask').attr('src')
  }

  $('#webcam-trigger').click(function() {
    $('.crop-wrapper').hide();
    $('#dialog:ui-dialog').dialog('destroy');

    $('#cam-modal input[type=button]').button();
    $('#cam-modal').dialog({
      modal: true, draggable: false, resizable: false,
      width: 680, height: 620,
      close: function(evt, ui) {
        $('#member_photo_base64').val('');
      }
    });
    $('#cam-mask').hide();
    $("#cam-embed").scriptcam(camOptions);
    return false;
  });
}

function initCropper() {
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

    $('#member_crop_x').val(Math.round(coords.x));
    $('#member_crop_y').val(Math.round(coords.y));
    $('#member_crop_w').val(Math.round(coords.w));
    $('#member_crop_h').val(Math.round(coords.h));
  }

  var aspectRatio = 140/200;
  var initial = {
    x: Number($('#member_crop_x').val()), y: Number($('#member_crop_y').val()),
    w: Number($('#member_crop_w').val()), h: Number($('#member_crop_h').val())
  }

  $('#crop-image').Jcrop({
    setSelect: [initial.x, initial.y, initial.x + initial.w, initial.y + initial.h],
    aspectRatio: aspectRatio, minSize: [140, 200],
    onChange: updateCrop,
    onSelect: updateCrop
  }, function() {
    var currentSelect = this.tellSelect(),
        width = $('#crop-image').width(),
        height = $('#crop-image').height(),
        select = [0, 0, width, height];

    if(currentSelect.w != 0 && currentSelect.h != 0) return;

    if(width / height > aspectRatio) {
      select[0] = (width - aspectRatio * height) / 2;
      select[2] = select[0] + aspectRatio * height;
    }
    else {
      select[1] = (height - width / aspectRatio) / 2;
      select[3] = select[1] + width / aspectRatio;
    }
    this.setSelect(select);
  });
}
