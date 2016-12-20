if (typeof qa == "undefined") {
    qa = {};
}

qa.template = function ($) {
    var _onScroll = function () {
        $('header').toggleClass('headerSticky', $(this).scrollTop() > 1);
        if ($(document).scrollTop() > 300 && !qa.utilities.isMobileDevice()) {
            _showFeatures();
        };
    };

    var _showFeatures = function() {
        $('.featureBoxOne').addClass('FeatureShow');
        $('.featureBoxTwo').addClass('FeatureShow');
        $('.featureBoxThree').addClass('FeatureShow');
    };

    var _setParallax = function () {
        $('#parallaxHome').parallax("50%", 0.3);
        $('.parallaxHomeLayer').parallax("50%", 0.6);
        $('#parallaxAbout').parallax("50%", 0.3);
    };

    var _setOnScroll = function () {
        $(document).scroll(qa.template.onScroll);
        if (qa.utilities.isMobileDevice()) {
            _showFeatures();
        }
    };

    var _setupQ2Overview = function() {
        $('legend a', $('#ContentArea')).click(function(event) {
            var $this = $(this);
            event.preventDefault();
            var text = $this.parent().next('div');
            text.toggleClass('expandText');

            $('span', $this).toggleClass('expanded');
        });
    };

    var _setupQ3Overview = function() {
        $('legend a', $('#ContentArea')).click(function(event) {
            var $this = $(this);
            event.preventDefault();
            var text = $this.parent().next('div');
            text.toggleClass('expandText');

            $('span', $this).toggleClass('expanded');
        });
    };

    var _setUpAbout = function(){
        $('.teamMember_1').each(function(index, el) {
            var $this=$(this);
            $('.linkAbout', $this).click(function(event){
                event.preventDefault();
                var aboutMember = $('.aboutMember', $(this).parent('.photo').parent('.teamMember_1'));
                var imgColor = $('img', $(this).parent('.photo'));
                aboutMember.toggleClass('showAbout');
                imgColor.toggleClass('colorPhoto')
            });
            $('.closeAbout', $this).click(function(event){
                event.preventDefault();
                $(this).parents('.aboutMember').first().removeClass('showAbout');
                $(this).parents('.teamMember_1').first().find('img').removeClass('colorPhoto');
            });
        });
        $('.teamMember_2').each(function (index, el) {
            var $this = $(this);
            $('.linkAbout', $this).click(function (event) {
                event.preventDefault();
                var aboutMember = $('.aboutMember', $(this).parent('.photo').parent('.teamMember_2'));
                var imgColor = $('img', $(this).parent('.photo'));
                aboutMember.toggleClass('showAbout');
                imgColor.toggleClass('colorPhoto')
            });
            $('.closeAbout', $this).click(function (event) {
                event.preventDefault();
                $(this).parents('.aboutMember').first().removeClass('showAbout');
                $(this).parents('.teamMember_2').first().find('img').removeClass('colorPhoto');
            });
        });
        $('.teamMember_3').each(function (index, el) {
            var $this = $(this);
            $('.linkAbout', $this).click(function (event) {
                event.preventDefault();
                var aboutMember = $('.aboutMember', $(this).parent('.photo').parent('.teamMember_3'));
                var imgColor = $('img', $(this).parent('.photo'));
                aboutMember.toggleClass('showAbout');
                imgColor.toggleClass('colorPhoto')
            });
            $('.closeAbout', $this).click(function (event) {
                event.preventDefault();
                $(this).parents('.aboutMember').first().removeClass('showAbout');
                $(this).parents('.teamMember_3').first().find('img').removeClass('colorPhoto');
            });
        });
    };


    return {
        onScroll: _onScroll,
        setParallax: _setParallax,
        setOnScroll: _setOnScroll,
        setUpAbout: _setUpAbout,
        setupQ2Overview: _setupQ2Overview,
        setupQ3Overview: _setupQ3Overview
    };
}(jQuery);