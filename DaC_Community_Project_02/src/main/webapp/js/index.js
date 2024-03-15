
    // menubar jQuery
	$(document).ready(function() {

		var w = $("#gnb ul li").width();

		$("#gnb").append("<span></span>");

		$("#gnb ul li").on("mouseenter focusin", function() {

			var index = $(this).index(); // index() 메서드는 각 li의 index를 취득하는 메서드입니다.

			console.log(index); // 각 li에 마우스를 오버하면 0, 1, 2, 3

			$(this).find("a").addClass("on");
			$(this).siblings().find("a").removeClass("on");
			$("#gnb span").stop().animate({

				left: index * w // 0 * 150, 1 *  150, 2 * 150, 3 * 150

			}, "fast", "swing");
		});

		$("#gnb ul li:eq(0)").trigger("mouseenter");

	});

    //slide
    $(document).ready(function(){
    
        setInterval(function(){
            $('div.slidebanner ul').animate({
                top: "-300"
            },1000,function(){
                $('div.slidebanner ul').append($('div.slidebanner ul li').eq(0));
                $('div.slidebanner ul').css("top",0);
            })
        },3000);
    })