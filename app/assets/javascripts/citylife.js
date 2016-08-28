$(function() {
    $('.refresh-export').bind('ajax:complete', function() {
        var club =  $(this).closest('.club');
        club.addClass('generating');

        var export_status_url = $(this).data('status-url');
        if (export_status_url)  {
            poll = function() {
                setTimeout( function() {
                    $.get(export_status_url)
                        .done(function(html) {
                            club.find('.export-date').html(html);
                            club.removeClass('generating no-export')
                        })
                        .fail(function(data) { poll()})
                }, 3000)
            };
            poll();
        }
    });
});
