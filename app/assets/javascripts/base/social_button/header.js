(function(w,d){
    try {
        var s, e = d.getElementsByTagName("script")[0],
            a = function (u, f) {
                if (!d.getElementById(f)) {
                    s = d.createElement("script");
                    s.async = !0;
                    s.src = u;
                    if (f) {
                        s.id = f;
                    }
                    e.parentNode.insertBefore(s, e);
                }
            };

        a("https://apis.google.com/js/plusone.js");
        a("//b.st-hatena.com/js/bookmark_button_wo_al.js");
        a("//platform.twitter.com/widgets.js", "twitter-wjs");
        a("https://widgets.getpocket.com/v1/j/btn.js?v=1");
    } catch (e) {
        console.log('Social buttons will not work')
    }
})(this, document);