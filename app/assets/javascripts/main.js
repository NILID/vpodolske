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
    // Search Slide
    /*==============================================================*/
   (function() {

        $('.search-icon').on('click', function() {
            $('.searchNlogin').toggleClass("expanded");
        });
    }());


    /*==============================================================*/
    // TheiaStickySidebar
    /*==============================================================*/

   (function() {

        $('.tr-sticky')
            .theiaStickySidebar({
                additionalMarginTop: 0
            });
    }());


    /*==============================================================*/
    // carouFredSel
    /*==============================================================*/

   (function() {

        $('.breaking-news-slider').carouFredSel({
            width: '100%',
            direction   : "bottom",
            scroll : 400,
            items: {
                visible: '+3'
            },
            auto: {
                items: 1,
                timeoutDuration : 4000
            },
            prev: {
                button: '.prev',
                items: 1
            },
            next: {
                button: '.next',
                items: 1
            }
        });

    }());


	/*==============================================================*/
	// Animationend
	/*==============================================================*/


    (function( $ ) {

        //Function to animate slider captions 
        function doAnimations( elems ) {
            //Cache the animationend event in a variable
            var animEndEv = 'webkitAnimationEnd animationend';

            elems.each(function () {
                var $this = $(this),
                    $animationType = $this.data('animation');
                $this.addClass($animationType).one(animEndEv, function () {
                    $this.removeClass($animationType);
                });
            });
        }

        //Variables on page load
        var $myCarousel = $('#home-carousel'),
            $firstAnimatingElems = $myCarousel.find('.item:first').find("[data-animation ^= 'animated']");

        //Initialize carousel
        $myCarousel.carousel();

        //Animate captions in first slide on page load 
        doAnimations($firstAnimatingElems);

        //Pause carousel
        $myCarousel.carousel('pause');

        //Other slides to be animated on carousel slide event 
        $myCarousel.on('slide.bs.carousel', function (e) {
            var $animatingElems = $(e.relatedTarget).find("[data-animation ^= 'animated']");
            doAnimations($animatingElems);
        });

    })(jQuery);

// script end
});
