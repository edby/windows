if (typeof qa == "undefined") {
    qa = {};
}

qa.utilities = function ($) {
    var _isIpad = function() {
        return navigator.userAgent.indexOf("iPad") != -1;
    };
    var _isIphone = function() {
        return navigator.userAgent.indexOf("iPhone") != -1;
    };
    var _isAndroid = function() {
        return navigator.userAgent.indexOf("Android") != -1;
    };
    var _isMobileDevice = function() {
        return _isAndroid() || _isIpad() || _isIphone();
    };

    var _isChrome = function() {
        var windowChrome = !!window.chrome;
        if (!windowChrome) {
            var pattern = /crios/i;
            return pattern.test(window.navigator.userAgent);
        } else {
            return windowChrome;
        }
    };
    var _getOrientation = function() {
        var orientation = window.orientation;
        if (orientation === undefined) {
            if (document.documentElement.clientWidth > document.documentElement.clientHeight)
                orientation = 'landscape';
            else
                orientation = 'portrait';
        } else if (orientation === 0 || orientation === 180)
            orientation = 'portrait';
        else
            orientation = 'landscape';


        return orientation;
    };

    return {
        isMobileDevice: _isMobileDevice,
        getOrientation: _getOrientation,
        isChrome: _isChrome
    };
}(jQuery);