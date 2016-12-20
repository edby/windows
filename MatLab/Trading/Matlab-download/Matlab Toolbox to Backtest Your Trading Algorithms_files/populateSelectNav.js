(function($) {
    $(document).ready(function() {
        $(".Horizontal").parent().each(function() {
            if ($(this).is("#MenuH")) {
                var mobile = $('<div class="mobile-menu" id="MenuM"><input type="button" id="MobileMenuOpen"></input><ul class="select"></ul></div>').insertAfter(this);

                var mainMenu = $('.CMSListMenuUL', this);
                var ulSelectMenu = $("ul.select", mobile);
                var menuOpenButton = $("#MobileMenuOpen", mobile);
                var activeMenuLabel = $('<span class="active-menu-label"></span>"');
                menuOpenButton.before(activeMenuLabel);
                ulSelectMenu.html(mainMenu.html());
                activeMenuLabel.text(ulSelectMenu.find('span.CMSListMenuLinkHighlighted').text());
                ulSelectMenu.find('*').removeAttr('class').removeAttr('style');
                ulSelectMenu.find('ul').hide();
                ulSelectMenu.find('li').each(function() {
                    var $li = $(this);
                    var $ul = $li.children('ul');
                    if ($ul.length > 0) {
                        var $button = $('<span class="toggle-submenu collapsed">></span>');
                        $li.children().first().after($button);
                        $button.click(function(event) {
                            event.preventDefault();
                            var otherUls = $li.siblings().find('ul').not($ul);
                            otherUls.hide();
                            otherUls.parent('li').find('span.toggle-submenu').removeClass('expanded').addClass('collapsed');
                            $ul.toggle();
                            $button.toggleClass('expanded', $ul.is(':visible')).toggleClass('collapsed', $ul.is(':hidden'));
                        });
                    }
                });
                menuOpenButton.click(function(event) {
                    event.preventDefault();
                    ulSelectMenu.toggle();
                });
                ulSelectMenu.hide();
            }

        });
    });
})(jQuery);