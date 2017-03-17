//index.js代码
/**
 * Created by wangqianqian02 on 16/11/23.
 */
function Scroller(a, b, c, d, e, f) {
    this.nav = $("#" + a),
        this.targetClass = c,
        this.navButton = $("#" + d),
        this.scrollType = b,
        this.currentIndex = 0,
        this.pos = {},
        this.moving = !1,
        this.speed = e,
        this.animateType = f
}
function Slider(a, b, c, d, e) {
    this.nav = $("." + a),
        this.content = $("." + b),
        this.speed = c,
        this.moveDistance = this.content.find("ul").width(),
        this.moveing = !1,
        this.timer = null,
        this.autoPlay = d,
        this.mouseOnIndex = null,
        this.currentSlide = null,
        this.animateType = e
}
var detect = function() {
    var a = navigator.userAgent.toLowerCase(),
        b = "ipad" == a.match(/ipad/i),
        c = "iphone os" == a.match(/iphone os/i),
        d = ("midp" == a.match(/midp/i), "rv:1.2.3.4" == a.match(/rv:1.2.3.4/i)),
        e = "ucweb" == a.match(/ucweb/i),
        f = "android" == a.match(/android/i),
        g = "windows ce" == a.match(/windows ce/i),
        h = "windows mobile" == a.match(/windows mobile/i),
        i = b || c || f || e || d || g || h;
    return i
};
Scroller.prototype.getElmentsPos = function() {
    for (var a = {},
             b = this.targetClass,
             c = 0; c < b.length; c++) {
        var d = b[c];
        a[d] = $("." + d).offset().top
    }
    return a
},
    Scroller.prototype.init = function() {
        this.renderView(),
            this.bindEvent()
    },
    Scroller.prototype.renderView = function() {
        if (detect()) {
            var a = 2280,
                b = 1620,
                c = $(window).width(),
                d = b * (c / a);
            $("body").css("min-width", "320px"),
                $("body").width(c),
                $(".header").width(c),
                $(".header").height(d / 13),
                $(".content").height(d),
                $(".content").width(c),
                $(".footer").width(c);
            for (var e = {},
                     f = this.targetClass,
                     g = 0; g < f.length; g++) {
                var h = f[g];
                e[h] = g * d
            }
            this.pos = e
        } else {
            var i = $(window).height(),
                b = 1620;
            $(".content").height(i);
            for (var e = {},
                     f = this.targetClass,
                     g = 0; g < f.length; g++) {
                var h = f[g];
                e[h] = g * i
            }
            this.pos = e
        }
    },
    Scroller.prototype.bindEvent = function() {
        {
            var a = this,
                b = this.pos,
                c = this.nav,
                d = this.navButton;
            a.targetClass.length
        }
        c.find("a").each(function(c, d) {
            d.onclick = function() {
                var c = this.hash,
                    d = c.replace("#", ""),
                    e = b[d];
                void 0 != e && (a.currentIndex = a.getCurrentIndex(d), a.moveTo(e))
            }
        }),
            d.on("click",
                function() {
                    a.throttle(a.moveDown)
                }),
            $("body").mousewheel(function(b, c) {
                if (b.stopPropagation(), b.preventDefault(), c > 0) {
                    if (a.moving) return;
                    a.throttle(a.moveUp, "", 50)
                } else {
                    if (a.moving) return;
                    a.throttle(a.scrollDown, "", 50)
                }
            }),
            $("body").keydown(function(b) {
                var c = b || window.event,
                    d = c.keyCode || c.which;
                switch (d) {
                    case 38:
                        a.throttle(a.moveUp);
                        break;
                    case 40:
                        a.throttle(a.moveDown)
                }
            }),
            $(window).resize(function() {
                a.renderView();
                var b = a.targetClass[a.currentIndex],
                    c = a.pos[b];
                a.throttle(a.moveTo, c)
            })
    },
    Scroller.prototype.getCurrentIndex = function(a) {
        var b = this.targetClass;
        for (var c in b) if (b[c] === a) return c
    },
    Scroller.prototype.moveTo = function(a) {
        var b = this;
        this.currentIndex == this.targetClass.length - 1 ? this.navButton.addClass("nav-up") : this.navButton.removeClass("nav-up"),
            $("html,body").animate({
                    scrollTop: a
                },
                {
                    easing: b.animateType,
                    duration: b.speed,
                    complete: function() {}
                })
    },
    Scroller.prototype.moveUp = function() {
        var a = this,
            b = this.pos,
            c = this.currentIndex,
            d = this.targetClass.length;
        if (c > 0) {
            this.currentIndex--,
                this.moving = !0;
            var e = this.targetClass[this.currentIndex],
                f = b[e];
            $("html,body").animate({
                    scrollTop: f
                },
                {
                    easing: a.animateType,
                    duration: a.speed,
                    complete: function() {
                        a.moving = !1,
                        a.currentIndex < d - 1 && a.navButton.removeClass("nav-up")
                    }
                })
        }
    },
    Scroller.prototype.moveDown = function() {
        var a = this,
            b = this.pos,
            c = this.currentIndex,
            d = this.targetClass.length;
        if (d - 1 > c) {
            this.currentIndex++;
            var e = this.targetClass[this.currentIndex];
            this.moving = !0;
            var f = b[e];
            $("html,body").animate({
                    scrollTop: f
                },
                {
                    easing: a.animateType,
                    duration: a.speed,
                    complete: function() {
                        a.moving = !1,
                        a.currentIndex == d - 1 && a.navButton.addClass("nav-up")
                    }
                })
        } else {
            this.moving = !0,
                this.currentIndex = 0;
            var e = this.targetClass[this.currentIndex],
                f = b[e];
            $("html,body").animate({
                    scrollTop: f
                },
                {
                    easing: a.animateType,
                    duration: a.speed,
                    complete: function() {
                        a.moving = !1,
                            a.navButton.removeClass("nav-up")
                    }
                })
        }
    },
    Scroller.prototype.scrollDown = function() {
        var a = this,
            b = this.pos,
            c = this.currentIndex,
            d = this.targetClass.length;
        if (d - 1 > c) {
            this.currentIndex++;
            var e = this.targetClass[this.currentIndex];
            this.moving = !0;
            var f = b[e];
            $("html,body").animate({
                    scrollTop: f
                },
                {
                    easing: a.animateType,
                    duration: a.speed,
                    complete: function() {
                        a.moving = !1,
                            a.currentIndex == d - 1 ? a.navButton.addClass("nav-up") : a.navButton.removeClass("nav-up")
                    }
                })
        }
    },
    Scroller.prototype.throttle = function(a, b, c) {
        var c = c || 200,
            d = this;
        a.tId && clearTimeout(a.tId),
            a.tId = setTimeout(function() {
                    a.call(d, b)
                },
                c)
    },
    Slider.prototype.init = function() {
        this.bindEvent(),
        this.autoPlay && this.autoScroll()
    },
    Slider.prototype.bindEvent = function() {
        var a = this;
        this.nav.find("li").each(function(b, c) {
            c.onmousemove = function() {
                var c = this;
                if (a.autoPlay && clearInterval(a.timer), !a.moveing && b != a.mouseOnIndex) {
                    a.mouseOnIndex = b,
                        a.mouseOnElement = this,
                        a.nav.find("li").each(function(a, b) {
                            b.setAttribute("class", "")
                        });
                    var d = -b * a.moveDistance;
                    a.currentSlide = b,
                        a.scrollTo(d,
                            function() {
                                a.moveing = !1,
                                    c.setAttribute("class", "selected")
                            })
                }
            },
                c.onmouseout = function() {
                    a.mouseOnIndex = null,
                    a.autoPlay && a.autoScroll()
                }
        })
    },
    Slider.prototype.autoScroll = function() {
        var a = this,
            b = this.nav.find("li").length,
            c = 0;
        this.timer = setInterval(function() {
                a.nav.find("li").each(function(a, b) {
                    b.setAttribute("class", "")
                }),
                    c++,
                c == b && (c = 0),
                    a.nav.find("li")[c].setAttribute("class", "selected");
                var d = -c * a.moveDistance;
                a.moveing || a.scrollTo(d)
            },
            a.speed)
    },
    Slider.prototype.scrollTo = function(a, b) {
        var c = this;
        this.moveing = !0,
            this.content.animate({
                    left: a
                },
                {
                    easing: c.animateType,
                    duration: c.speed,
                    complete: function() {
                        c.moveing = !1,
                        null != c.mouseOnIndex && c.mouseOnIndex != c.currentSlide && (c.mouseOnIndex = null, $(c.mouseOnElement).trigger("mousemove")),
                        b && b()
                    }
                })
    },
    $(function() {
        var a = new Scroller("nav", "vertical", ["product-show", "product-function", "product-advantage", "join-us", "footer"], "navButton", 500, "easeOutQuint");
        a.init();
        var b = new Slider("slider-nav", "slider-content", 300, !1, "easeOutQuint");
        b.init(),
            $(".carousel").carousel({
                interval: 4e3,
                pause: "none"
            }),
        navigator.userAgent.indexOf("MSIE 8.0") > 0 && ($(".product-show").css("filter", "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='image/product-show.jpg', sizingMethod='scale')"), $(".product-advantage").css("filter", "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='image/product-advantage.jpg', sizingMethod='scale')"), $(".join-us").css("filter", "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='image/join-us.jpg', sizingMethod='scale')"))
    }),
    function(a) {
        var b = "http://login.bce.baidu.com/",
            c = '<a href="' + b + '">登录</a><a href="https://u.baidu.com/ucweb/?module=Reguser&controller=reg&action=index&appid=285" target="_blank">注册</a>',
            d = function() {
                var a = navigator.userAgent.toLowerCase(),
                    b = "ipad" == a.match(/ipad/i),
                    c = "iphone os" == a.match(/iphone os/i),
                    d = ("midp" == a.match(/midp/i), "rv:1.2.3.4" == a.match(/rv:1.2.3.4/i)),
                    e = "ucweb" == a.match(/ucweb/i),
                    f = "android" == a.match(/android/i),
                    g = "windows ce" == a.match(/windows ce/i),
                    h = "windows mobile" == a.match(/windows mobile/i),
                    i = b || c || f || e || d || g || h;
                return i
            };
        return d() ? (a(".login").html(""), void a("#helpLi").hide()) : void a.ajax({
            url: " /api/account/displayName",
            type: "POST",
            dataType: "json",
            timeout: 3e3,
            error: function() {
                a(".login").html(c)
            },
            success: function(b) {
                if (b.result) {
                    var d = b.result.displayName,
                        e = "",
                        f = a.cookie("bce-login-type"),
                        g = "http%3A%2F%2Fbce.baidu.com";
                    "UC" == f ? e = "http://cas.baidu.com/?action=logout&u=" + g: "PASSPORT" == f && (e = "http://passport.baidu.com/?logout&u=" + g);
                    var h = '<span id="userName">' + d + '</span><span class="down-triangle"></span><div class="inner-nav  clearfix"><a href="' + e + '">退出</a></div>';
                    a(".login").html(h)
                } else a(".login").html(c)
            }
        })
    } (window.jQuery);
var currentUrl = location.href;
if (currentUrl.indexOf("bce.baidu.com") > 0) {
    var _hmt = _hmt || [],
        _bdhmProtocol = "https:" == document.location.protocol ? " https://": " http://";
    document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F28a17f66627d87f1d046eae152a1c93d' type='text/javascript'%3E%3C/script%3E"))
} !
    function(a) {
        "use strict";
        a(function() {
            a.support.transition = function() {
                var a = function() {
                    var a, b = document.createElement("bootstrap"),
                        c = {
                            WebkitTransition: "webkitTransitionEnd",
                            MozTransition: "transitionend",
                            OTransition: "oTransitionEnd otransitionend",
                            transition: "transitionend"
                        };
                    for (a in c) if (void 0 !== b.style[a]) return c[a]
                } ();
                return a && {
                        end: a
                    }
            } ()
        })
    } (window.jQuery),
    !
        function(a) {
            "use strict";
            var b = function(b, c) {
                this.$element = a(b),
                    this.$indicators = this.$element.find(".carousel-indicators"),
                    this.options = c,
                "hover" == this.options.pause && this.$element.on("mouseenter", a.proxy(this.pause, this)).on("mouseleave", a.proxy(this.cycle, this))
            };
            b.prototype = {
                cycle: function(b) {
                    return b || (this.paused = !1),
                    this.interval && clearInterval(this.interval),
                    this.options.interval && !this.paused && (this.interval = setInterval(a.proxy(this.next, this), this.options.interval)),
                        this
                },
                getActiveIndex: function() {
                    return this.$active = this.$element.find(".item.active"),
                        this.$items = this.$active.parent().children(),
                        this.$items.index(this.$active)
                },
                to: function(b) {
                    var c = this.getActiveIndex(),
                        d = this;
                    if (! (b > this.$items.length - 1 || 0 > b)) return this.sliding ? this.$element.one("slid",
                        function() {
                            d.to(b)
                        }) : c == b ? this.pause().cycle() : this.slide(b > c ? "next": "prev", a(this.$items[b]))
                },
                pause: function(b) {
                    return b || (this.paused = !0),
                    this.$element.find(".next, .prev").length && a.support.transition.end && (this.$element.trigger(a.support.transition.end), this.cycle(!0)),
                        clearInterval(this.interval),
                        this.interval = null,
                        this
                },
                next: function() {
                    return this.sliding ? void 0 : this.slide("next")
                },
                prev: function() {
                    return this.sliding ? void 0 : this.slide("prev")
                },
                slide: function(b, c) {
                    var d, e = this.$element.find(".item.active"),
                        f = c || e[b](),
                        g = this.interval,
                        h = "next" == b ? "left": "right",
                        i = "next" == b ? "first": "last",
                        j = this;
                    if (this.sliding = !0, g && this.pause(), f = f.length ? f: this.$element.find(".item")[i](), d = a.Event("slide", {
                            relatedTarget: f[0],
                            direction: h
                        }), !f.hasClass("active")) {
                        if (this.$indicators.length && (this.$indicators.find(".active").removeClass("active"), this.$element.one("slid",
                                function() {
                                    var b = a(j.$indicators.children()[j.getActiveIndex()]);
                                    b && b.addClass("active")
                                })), a.support.transition && this.$element.hasClass("slide")) {
                            if (this.$element.trigger(d), d.isDefaultPrevented()) return;
                            f.addClass(b),
                                f[0].offsetWidth,
                                e.addClass(h),
                                f.addClass(h),
                                this.$element.one(a.support.transition.end,
                                    function() {
                                        f.removeClass([b, h].join(" ")).addClass("active"),
                                            e.removeClass(["active", h].join(" ")),
                                            j.sliding = !1,
                                            setTimeout(function() {
                                                    j.$element.trigger("slid")
                                                },
                                                0)
                                    })
                        } else {
                            if (this.$element.trigger(d), d.isDefaultPrevented()) return;
                            e.removeClass("active"),
                                f.addClass("active"),
                                this.sliding = !1,
                                this.$element.trigger("slid")
                        }
                        return g && this.cycle(),
                            this
                    }
                }
            };
            var c = a.fn.carousel;
            a.fn.carousel = function(c) {
                return this.each(function() {
                    var d = a(this),
                        e = d.data("carousel"),
                        f = a.extend({},
                            a.fn.carousel.defaults, "object" == typeof c && c),
                        g = "string" == typeof c ? c: f.slide;
                    e || d.data("carousel", e = new b(this, f)),
                        "number" == typeof c ? e.to(c) : g ? e[g]() : f.interval && e.pause().cycle()
                })
            },
                a.fn.carousel.defaults = {
                    interval: 5e3,
                    pause: "hover"
                },
                a.fn.carousel.Constructor = b,
                a.fn.carousel.noConflict = function() {
                    return a.fn.carousel = c,
                        this
                },
                a(document).on("click.carousel.data-api", "[data-slide], [data-slide-to]",
                    function(b) {
                        var c, d, e = a(this),
                            f = a(e.attr("data-target") || (c = e.attr("href")) && c.replace(/.*(?=#[^\s]+$)/, "")),
                            g = a.extend({},
                                f.data(), e.data());
                        f.carousel(g),
                        (d = e.attr("data-slide-to")) && f.data("carousel").pause().to(d).cycle(),
                            b.preventDefault()
                    })
        } (window.jQuery);
        
// custom.js代码
/* Navigation */

$(document).ready(function () {

    $(window).resize(function () {
        if ($(window).width() >= 765) {
            $('.sidebar #side-nav').slideDown(350);
        }
        else {
            $('.sidebar #side-nav').slideUp(350);
        }
    });

    $('#side-nav > li > a').on('click', function (e) {
        if ($(this).parent().hasClass('has_sub')) {
            e.preventDefault();
        }
        if ($(this).hasClass('subdrop')) {
            $(this).removeClass('subdrop');
            $(this).next('ul').slideUp(350);
        }
        else if (!$(this).hasClass('subdrop')) {
            $(this).next('ul').slideDown(350);
            $(this).addClass('subdrop');
        }
    });
});

$(document).ready(function () {
    $('.sidebar-dropdown a').on('click', function (e) {
        e.preventDefault();

        if (!$(this).hasClass('open')) {
            // hide any open menus and remove all other classes
            $('.sidebar #side-nav').slideUp(350);
            $('.sidebar-dropdown a').removeClass('open');

            // open our new menu and add the open class
            $('.sidebar #side-nav').slideDown(350);
            $(this).addClass('open');
        }

        else if ($(this).hasClass('open')) {
            $(this).removeClass('open');
            $('.sidebar #side-nav').slideUp(350);
        }
    });

});

/* Scroll to Top */


$('.totop').hide();

$(function () {
    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            $('.totop').slideDown();
        }
        else {
            $('.totop').slideUp();
        }
    });

    $('.totop a').click(function (e) {
        e.preventDefault();
        $('body,html').animate({scrollTop: 0}, 500);
    });

});

        
