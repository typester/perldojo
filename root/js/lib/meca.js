(function() {

$.fn.meca = function(action, conf) {
    return this.each(function() {
        funcs[action].call(this, conf);
    });
};

var is_msie6 = ($.browser.msie && $.browser.version < 7);

var filterStyle = function(src, sizing) {
    var dx = 'DXImageTransform.Microsoft.AlphaImageLoader';
    return 'progid:' + dx + '(src="' + src + '",sizingMethod=' + sizing +')';
};

var funcs = {
    hover: function(conf) {
        var $elem = $(this);
        var conf  = $.extend({ postfix:  '_o' }, conf);

        var src  = $elem.attr('src');
        if (!src) return;

        var src_o = src.replace(/\.\w+$/, conf.postfix + '$&');
        var img   = new Image();
        img.src   = src_o;

        $elem.hover(
            function() { this.src = src_o; },
            function() { this.src = src; }
        );
    },

    external: function() {
        $(this).attr('target', '_blank');
    },

    pngfix: function(conf) {
        if (!is_msie6) return;

        var $elem = $(this);
        var conf  = $.extend({
            hoverSelector: '.btn',
            hoverPostfix:  '_o',
            blankGif:      false,
            wrapSpanClass: 'imgpngWrapSpan'
        }, conf);

        var css = {
            'filter': filterStyle($elem.attr('src'), 'crop'),
            'width':  $elem.width(),
            'height': $elem.height(),
            'zoom':   '1'
        };

        var apply = function($elem) {
            if (conf.blankGif) {
                $elem.css(css).attr('src', conf.blankGif);
                return $elem;
            }
            else {
                var wrapSpan = $('<span/>').addClass(conf.wrapSpanClass).css(css);
                $elem.css('visibility', 'hidden').wrap(wrapSpan);
                return $elem.parent();
            }
        };

        if ( $elem.is(conf.hoverSelector) ) {
            var src = $elem.attr('src');
            var src_o = src.replace(/\.\w+$/, conf.hoverPostfix + '$&');
            var img = new Image();
            img.src = src_o;

            apply($elem).hover(
                function() { $(this).css('filter', filterStyle(src_o, 'proc')) },
                function() { $(this).css('filter', filterStyle(src, 'proc')) }
            );
        }
        else {
            apply($elem);
        }
    },

    bgpngfix: function() {
        if (!is_msie6) return;

        var $elem = $(this);

        var filter = filterStyle(
            $elem.css('backgroundImage').slice(5,-2),
            ($elem.css('backgroundRepeat') === 'no-repeat') ? 'crop' : 'scale'
        );

        $elem.css({
            'filter': filter,
            'background-image': 'none',
            'zoom': '1'
        });
    },

    heightAlign: function() {
        var maxHeight = 0;
        $(this).find('> *').each(function() {
            var height = $(this).height();
            if (maxHeight < height) {
                maxHeight = height;
            }
        }).height(maxHeight);
    },

    positionFixed: function() {
        if (!is_msie6) return;

        var elem = this;
        var $elem = $(elem);

        var baseTop  = parseInt($elem.css('top'))  || 0;
        var baseLeft = parseInt($elem.css('left')) || 0;

        $elem.css({
                position: 'absolute',
                top:  $(document).scrollTop()  + baseTop,
                left: $(document).scrollLeft() + baseLeft
            })
            .parents().each(function() {
                if ($(this).css('position') == 'relative') {
                    $(this).after($elem);
                }
            })
        ;

        $('html').css({
            'background-image': 'url(null)',
            'background-attachment': 'fixed'
        });

        elem['topVal'] = baseTop;
        elem.style.setExpression('top', 'documentElement.scrollTop + this.topVal + "px"');
    },

    smoothScroll: function(conf) {
        var conf = $.extend({
            noAddHashList: ['#top']
        }, conf);

        var noAddHashList = conf.noAddHashList || [];

        $(this).click(function() {
            var $elem = $(this);

            var target_id = $elem.attr('href');
            try {
                var $target = $(target_id);
                if (!$target.length) return;
            }
            catch(e) {
                return;
            }

            $('html, body').animate(
                { scrollTop: $target.offset().top },
                'normal',
                'swing',
                function() {
                    if ($.inArray(target_id, noAddHashList) == -1) {
                        location.hash = target_id;
                    }
                }
            );
            return false;
        });
    },

    addOsClass: function(conf) {
        var $elem = $(this);
        var conf = $.extend({
            winClass: 'osWin',
            macClass: 'osMac'
        }, conf);

        var ua = navigator.userAgent.toLowerCase();
        if (/windows/.test(ua)) {
            $elem.addClass(conf.winClass);
        }
        else if (/mac os x/.test(ua)) {
            $elem.addClass(conf.macClass);
        }
    },

    labelClickable: function() {
        if(!$.browser.msie) return;

        $(this).click(function() {
            $('#' + $(this).parents('label').attr('for')).focus().click();
        });
    },

    active: function(conf) {
        var $elem = $(this);
        var conf  = $.extend({
            postfix:       '_a',
            hoverSelector: '.btn',
            hoverPostfix:  '_o'
        }, conf);

        if (!$elem.attr('src')) return;

        var src   = this.src;
        var src_a = this.src.replace(/\.\w+$/, conf.postfix + '$&');
        var src_base = src;
        if (conf.hoverSelector && $elem.is(conf.hoverSelector)) {
            src_base = src.replace(/\.\w+$/, conf.hoverPostfix + '$&');
        }

        var img = new Image();
        img.src = src_a;

        $elem.mousedown(function() { this.src = src_a; });
        $elem.mouseup(function()   { this.src = src_base });
    },

    placeholder: function(conf) {
        var $elem = $(this);
        var conf = $.extend({
            placeholderClass: 'hasPlaceholder',
            target_attr: 'placeholder'
        }, conf);

        var placeholder = $(this).attr(conf.target_attr);

        if ($elem.val() == '' || $elem.val() == placeholder) {
            $elem.val(placeholder).addClass(conf.placeholderClass);
        }

        $elem
            .focus(function() {
                if ( $elem.val() == placeholder ) {
                    $elem.val('').removeClass(conf.placeholderClass)
                }
            })
            .blur(function() {
                if ( $elem.val() == '' ) {
                    $elem.val(placeholder).addClass(conf.placeholderClass);
                }
            })
            .parents('form').bind('submit', function() {
                if ($elem.val() == placeholder) {
                    $elem.val('')
                }
            });
        ;
    }
};

})();
