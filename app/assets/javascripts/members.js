// Utilities for the backend pages
$(function() {
  function initFilters() {
    var filters = $('#filters');
    var expand = $('a.icon.expand').click(function() {
      filters.show('blind');
      $(this).parent().hide('blind');
      return false;
    });
    $('a.icon.collapse').click(function() {
      filters.hide('blind');
      expand.parent().show('blind');
      return false;
    })
  }

  function initPhotoOverlay() {
    $('a.icon.photo').tooltip({
      show: false, hide: false, track: true,
      content: function() {
        return $('<img>')
                 .attr('src', $(this).data('photo'))
                 .attr('width', 140).attr('height', 200)
      }
    });
  }

  if($('body').hasClass('backend')) {
    initFilters();
    initPhotoOverlay();
  }
})
