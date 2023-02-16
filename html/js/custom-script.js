$('.toggle-side').click(function(){
  $(".side-menu").toggleClass("show")
})

$('.close-side').click(function(){
  $(".side-menu").toggleClass("show")
})


$(function() {

  $('.loop').on('initialized.owl.carousel translate.owl.carousel', function(e) {
    idx = e.item.index;
    $('.owl-item.big').removeClass('big');
    $('.owl-item').eq(idx).addClass('big');
  });


  $('.loop').owlCarousel({
    center: true,
    items: 5,
    loop: true,
    margin: 10,
    autoplay: true,
    autoPlay: 3000
  })
});