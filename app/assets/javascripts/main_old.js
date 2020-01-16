$(function() {

   $("a.gallery").fancybox({
        'transitionIn': 'elastic',
        'transitionOut' : 'elastic',
        'speedIn': 600,
        'speedOut': 200,
        'overlayShow': false,
        closeBtn: false,
        helpers : {
          title : {type :'inside'},
          buttons: {},
          thumbs : {
            width : 50,
            height: 50
          }
        },
        tpl : {
            next : '<a title="Следующее" class="fancybox-item fancybox-next"><span></span></a>',
            prev: '<a title="Предыдущее" class="fancybox-item fancybox-prev"><span></span></a>',
            closeBtn: '<div title="Закрыть" class="fancybox-item fancybox-close"></div>',
            error: '<p class="fancybox-error">Запрошенный элемент не доступен.<br/>Пожалуйста попробуйте попозже.</p>'
        }
   });

  $('.dropdown-toggle').dropdown();
});
