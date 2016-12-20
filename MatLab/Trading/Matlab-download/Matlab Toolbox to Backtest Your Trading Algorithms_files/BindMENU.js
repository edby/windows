(function (b) {
    showDefaultMenu = function (j, o, l, k) {
        b("ul:first", l).children("ul").show();
        if (b(l).find("ul").is(".submenu")) {
            var m = b(l).children("ul.submenu");
            if (o.Orientation.toLowerCase() == "vertical" || b(l).parent().is(".submenu")) {
                m.css("left", m.parent().outerWidth(true));
                b(l).css("position", "relative");
                var p = b(l).children("a,span").offset().top - b(l).offset().top;
                p = p + b(l).children("a,span").outerHeight(true);
                m.css("margin-top", "-" + p + "px");
                m.css("margin-left", "0px");
                var a = b(l).offset().left + b(l).outerWidth(true);
                if (a + m.outerWidth() > b(window).width()) {
                    m.css("left", "0px").css("left", "-" + m.outerWidth() + "px")
                }
            } else {
                var n = b(l).children("a,span").offset().left - b(l).offset().left;
                if (n > 0) {
                    m.css("margin-left", "-" + n + "px")
                }
            }
        }
        b("ul:first", l).slideDown(k);
        b("ul:first", l).css('overflow', '');
    };
    hideDefaultMenu = function (f, a, h, g) {
        b("ul.submenu:first", h).hide()
    };
    showAccordionMenu = function (f, a, h, g) {
        if (b(h).children("ul").is(".submenu")) {
            b("ul", h).show().css("position", "relative");
            b(h).children("ul").slideDown(g)
        }
    };
    hideAccordionMenu = function (f, a, h, g) {
        if (b(h).children("ul").is(".submenu")) {
            b(h).children("ul").slideUp(g)
        }
    };
    showMegaMenu = function (u, m, r, s) {
        b("ul.submenu", u).hide();
        var q = b(r).parent().offset().left + b(r).parent().outerWidth(true);
        if (b(r).children("ul").is(".submenu")) {
            var v = b(r).children("ul.submenu");
            v.css("position", "absolute");
            if (m.Orientation.toLowerCase() == "vertical") {
                v.css("left", v.parent().outerWidth(true));
                b(r).css("position", "relative");
                var o = b(r).children("a,span").offset().top - b(r).offset().top;
                o = o + b(r).children("a,span").outerHeight(true);
                v.css("margin-top", "-" + o + "px");
                v.css("margin-left", "0px");
                var a = b(r).offset().left + b(r).outerWidth(true);
                if (a + v.outerWidth() > b(window).width()) {
                    v.css("left", "0px").css("left", "-" + v.outerWidth() + "px")
                }
            } else {
                var t = b(r).find("a,span").offset().left - b(r).offset().left;
                if (t > 0) {
                    v.css("margin-left", "-" + t + "px")
                }
                var n = b(r).find("a,span").offset().top - b(r).offset().top;
                if (n > 0) {
                    v.css("margin-top", n + "px")
                }
                v.css("opacity", "0").show();
                if (m.Orientation.toLowerCase() == "horizontal") {
                    var p = b(r).offset().left + v.outerWidth();
                    if (q < p) {
                        var o = p - q;
                        v.css("margin-left", t - o + "px")
                    }
                }
                v.hide().css("opacity", "1")
            }
        }
        b("ul.submenu", r).slideDown(s)
    };
    hideMegaMenu = function (f, a, h, g) {
        b("ul.submenu", f).hide()
    };
    b.fn.BindMENU = function (a) {
        var g = "fast";
        var h = "hover";
        if (a.Speed != null) {
            g = a.Speed.toLowerCase()
        }
        if (a.Event != null) {
            if ((a.Event.toLowerCase() == "hover") || (a.Event.toLowerCase() == "mouseover")) {
                h = "hover"
            } else {
                if ((a.Event.toLowerCase() == "click") || (a.Event.toLowerCase() == "mouseclick")) {
                    h = "click"
                }
            }
        }
        b("ul", this).addClass("submenu");
        b(".submenu", this).css("display", "none");
        if (navigator.userAgent.indexOf("MSIE 7") != -1) {
            b("ul.submenu", this).before('<div style="height: 0px; line-height: 0px; clear: both; overflow: hidden; font-size:0px; position:fixed" />')
        }
        var f = b(this);
        if ((a.Orientation.toLowerCase() == "horizontal" && a.MenuStyle.toLowerCase() == "accordion") || a.MenuStyle.toLowerCase() == "defaultmenu") {
            b("ul.submenu", this).hide().css("position", "absolute");
            if (h == "hover") {
                b("li", this).hover(function () {
                    showDefaultMenu(f, a, this, g)
                }, function () {
                    hideDefaultMenu(f, a, this, g)
                })
            } else {
                b("li > a, li > span", this).click(function (c) {
                    var d = b(this).parent("li");
                    if (b(d).children("ul").is(".submenu")) {
                        c.preventDefault();
                        if (b(d).children("ul").css("display") != "none") {
                            hideDefaultMenu(f, a, d, g)
                        } else {
                            b(this).closest("ul").children("li").children("a, span").not(this).parent().find("ul").hide();
                            showDefaultMenu(f, a, d, g)
                        }
                    } else {
                        b(f).find("ul.submenu").hide()
                    }
                })
            }
        }
        if (a.Orientation.toLowerCase() == "vertical" && a.MenuStyle.toLowerCase() == "accordion") {
            b(this).closest("#MenuV").addClass("accordion");
            b(this).children("li").children("ul").hide();
            if (h == "hover") {
                b(this).children("li").hover(function (c) {
                    c.stopPropagation();
                    showAccordionMenu(f, a, this, g)
                }, function (c) {
                    c.stopPropagation();
                    hideAccordionMenu(f, a, this, g)
                })
            } else {
                b("li > a, li > span", this).click(function (c) {
                    var d = b(this).parent("li");
                    if (b(d).children("ul").is(".submenu")) {
                        c.preventDefault();
                        c.stopPropagation();
                        if (b(d).children("ul").css("display") != "none") {
                            hideAccordionMenu(f, a, d, g)
                        } else {
                            showAccordionMenu(f, a, d, g)
                        }
                    }
                })
            }
        }
        if (a.MenuStyle.toLowerCase() == "megamenu") {
            b(this).parent().parent().addClass("megamenu");
            b(".submenu", this).css("display", "block");
            b(this).children("li").children("ul").each(function () {
                if (b(this).children("li").children("ul").is(".submenu")) {
                    b(this).parent().addClass("mega");
                    var d = b(this).outerWidth() - b(this).width();
                    var c = "0";
                    b(this).css("position", "absolute");
                    b(".submenu", this).css("display", "block").css("position", "relative");
                    b(this).children("li").css("display", "block").css("float", "left");
                    b(this).children("li").each(function () {
                        d += b(this).outerWidth(true);
                        if (b(this).outerHeight(true) > c) {
                            c = b(this).outerHeight(true)
                        }
                    });
                    b(this).children("li").css("min-height", c + "px");
                    b(this).css("min-width", d)
                }
            });
            b(this).children("li").children("ul").hide();
            if (h == "hover") {
                b(this).children("li").hover(function () {
                    showMegaMenu(f, a, this, g)
                }, function () {
                    hideMegaMenu(f, a, this, g)
                })
            } else {
                b("li > a, li > span", this).click(function (c) {
                    var d = b(this).parent("li");
                    if (b(d).children("ul").is(".submenu")) {
                        c.preventDefault();
                        if (b(d).children("ul").css("display") != "none") {
                            hideMegaMenu(f, a, d, g)
                        } else {
                            showMegaMenu(f, a, d, g)
                        }
                    } else {
                        b(f).find("ul.submenu").hide()
                    }
                })
            }
        }
    }
})(jQuery);