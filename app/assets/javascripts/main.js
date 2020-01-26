jQuery(function ($) {

    'use strict';

    // -------------------------------------------------------------
    // News Slider
    // -------------------------------------------------------------

    $(function (){

        var ticker = $('#ticker'),
            container = ticker.find('ul'),
            tickWidth = 1,
            speed = 0.1, // Control pace
            distance,
            timing;

            container.find("li").each(function(i) {
            tickWidth += $(this, i).outerWidth(true);
            });

            distance = tickWidth + (ticker.outerWidth() - $('#gameLabel').outerWidth());
            timing = distance / speed;

            function scrollIt(dist, dur) {
            container.animate({
              left: '-=' + dist
            }, dur, 'linear', function() {
              container.css({
                'left': ticker.outerWidth()
              });
              scrollIt(distance, timing);
            });
            }

            scrollIt(distance, timing);

            ticker.hover(function() {
            container.stop();
            }, function() {
            var offset = container.offset(),
              newPosition = offset.left + tickWidth,
              newTime = newPosition / speed;
            scrollIt(newPosition, newTime);
        });
    });

    /*==============================================================*/
    // TheiaStickySidebar
    /*==============================================================*/

   (function() {
        $('.tr-sticky')
            .theiaStickySidebar({
                additionalMarginTop: 0
            });
    }());
// script end
});
