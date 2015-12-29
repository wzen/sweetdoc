// Generated by CoffeeScript 1.9.2
var PageFlip;

PageFlip = (function() {
  function PageFlip() {}

  PageFlip.start = function(callback) {
    var canvas, height, sections, width;
    if (callback == null) {
      callback = null;
    }
    width = $('#pages').width();
    height = $('#pages').height();
    $(this).wrap("<div class='flip_gallery'>");
    sections = $(this).find(".section");
    canvas = $(document.createElement("canvas")).attr({
      width: width,
      height: height
    }).css({
      margin: 0,
      width: width + "px",
      height: height + "px"
    });
    $(this).css({
      position: "absolute",
      left: "-9000px",
      top: "-9000px"
    }).after(canvas);
    return this.run($(this).next(), width, height, sections, callback);
  };

  PageFlip.run = function(canvas, width, height, sections, callback) {
    var animationTimer, background, baseFlipX, baseFlipY, basemX, basemY, c, canvas2, cornerCurlIn, cornerCurlOut, cornerMove, cornersTop, ctx, ctx2, curlDuration, curlShape, curlSize, curling, dragging, draw, el, flip, flipDuration, flipping, gradientColors, inCanvas, index, init, lastmX, lastmY, loaded, mX, mY, mousedown, obj, onCorner, patterns, scale, sideLeft, startDate;
    obj = this;
    el = canvas.prev();
    index = 0;
    init = false;
    background = 'transparent';
    cornersTop = true;
    gradientColors = ['#4F2727', '#FF8F8F', '#F00'];
    curlSize = 0.1;
    scale = 'noresize';
    patterns = [];
    canvas2 = canvas.clone();
    ctx2 = canvas2[0].getContext("2d");
    ctx = canvas[0].getContext("2d");
    loaded = 0;
    sections = sections.each(function(i) {
      var section;
      if (patterns[i]) {
        return;
      }
      section = this;
      section.onload = function() {
        var r, rx, ry;
        r = 1;
        if (scale !== "noresize") {
          rx = width / this.width;
          ry = height / this.height;
          if (scale === "fit") {
            r = rx < 1 || ry < 1 ? Math.min(rx, ry) : 1;
          }
          if (scale === "fill") {
            r = Math.min(rx, ry);
          }
        }
        $(section).data("flip.scale", r);
        patterns[i] = ctx.createPattern(section, "no-repeat");
        loaded++;
        if (loaded === sections.length && !init) {
          init = true;
          return draw();
        }
      };
      if (section.complete) {
        return window.setTimeout(function() {
          return section.onload();
        }, 10);
      }
    });
    mX = width;
    mY = height;
    basemX = mX * (1 - curlSize);
    basemY = mY * curlSize;
    sideLeft = false;
    onCorner = false;
    curlDuration = 400;
    curling = false;
    animationTimer = null;
    startDate = null;
    flipDuration = 700;
    flipping = false;
    baseFlipX = null;
    baseFlipY = null;
    lastmX = null;
    lastmY = null;
    inCanvas = false;
    mousedown = false;
    dragging = false;
    c = canvas;
    c.mousemove(function(e) {
      var ofset;
      if (!ofset) {
        ofset = canvas.offset();
      }
      if (mousedown && onCorner) {
        if (!dragging) {
          dragging = true;
          window.clearInterval(animationTimer);
        }
        mX = !sideLeft ? e.pageX - ofset.left : width - (e.pageX - ofset.left);
        mY = cornersTop ? e.pageY - ofset.top : height - (e.pageY - ofset.top);
        window.setTimeout(draw, 0);
        return false;
      }
      lastmX = e.pageX || lastmX;
      lastmY = e.pageY || lastmY;
      if (!flipping) {
        sideLeft = (lastmX - ofset.left) < width / 2;
      }
      if (!flipping && ((lastmX - ofset.left) > basemX || (lastmX - ofset.left) < (width - basemX)) && ((cornersTop && (lastmY - ofset.top) < basemY) || (!cornersTop && (lastmY - ofset.top) > (height - basemY)))) {
        if (!onCorner) {
          onCorner = true;
          c.css("cursor", "pointer");
        }
      } else {
        if (onCorner) {
          onCorner = false;
          c.css("cursor", "default");
        }
      }
      return false;
    }).on("mouseenter", function(e) {
      inCanvas = true;
      if (flipping) {
        return;
      }
      window.clearInterval(animationTimer);
      startDate = new Date().getTime();
      animationTimer = window.setInterval(cornerCurlIn, 10);
      return false;
    }).on("mouseleave", function(e) {
      inCanvas = false;
      dragging = false;
      mousedown = false;
      if (flipping) {
        return;
      }
      window.clearInterval(animationTimer);
      startDate = new Date().getTime();
      animationTimer = window.setInterval(cornerCurlOut, 10);
      return false;
    }).click(function() {
      if (onCorner && !flipping) {
        flipping = true;
        c.triggerHandler("mousemove");
        window.clearInterval(animationTimer);
        startDate = new Date().getTime();
        baseFlipX = mX;
        baseFlipY = mY;
        animationTimer = window.setInterval(flip, 10);
        index += typeof sideLeft === "function" ? sideLeft(-{
          1: 1
        }) : void 0;
        if (index < 0) {
          index = sections.length - 1;
        }
        if (index === sections.length) {
          index = 0;
        }
        el.trigger("flip.jflip", [index, sections.length]);
      }
      return false;
    }).mousedown(function() {
      dragging = false;
      mousedown = true;
      return false;
    }).mouseup(function() {
      mousedown = false;
      return false;
    });
    flip = function() {
      var date, delta;
      date = new Date();
      delta = date.getTime() - startDate;
      if (delta >= flipDuration) {
        window.clearInterval(animationTimer);
        if (sideLeft) {
          sections.unshift(sections.pop());
          patterns.unshift(patterns.pop());
        } else {
          sections.push(sections.shift());
          patterns.push(patterns.shift());
        }
        mX = width;
        mY = height;
        draw();
        flipping = false;
        if (inCanvas) {
          startDate = new Date().getTime();
          animationTimer = window.setInterval(cornerCurlIn, 10);
          c.triggerHandler("mousemove");
        }
        return;
      }
      mX = baseFlipX - 2 * width * delta / flipDuration;
      mY = baseFlipY + 2 * height * delta / flipDuration;
      return draw();
    };
    cornerMove = function() {
      var date, delta, drawing;
      date = new Date();
      delta = date.getTime() - startDate;
      mX = basemX + Math.sin(Math.PI * 2 * delta / 1000);
      mY = basemY + Math.cos(Math.PI * 2 * delta / 1000);
      drawing = true;
      return window.setTimeout(draw, 0);
    };
    cornerCurlIn = function() {
      var date, delta;
      date = new Date();
      delta = date.getTime() - startDate;
      if (delta >= curlDuration) {
        window.clearInterval(animationTimer);
        startDate = new Date().getTime();
        animationTimer = window.setInterval(cornerMove, 10);
      }
      mX = width - (width - basemX) * delta / curlDuration;
      mY = basemY * delta / curlDuration;
      return draw();
    };
    cornerCurlOut = function() {
      var date, delta;
      date = new Date();
      delta = date.getTime() - startDate;
      if (delta >= curlDuration) {
        window.clearInterval(animationTimer);
      }
      mX = basemX + (width - basemX) * delta / curlDuration;
      mY = basemY - basemY * delta / curlDuration;
      return draw();
    };
    curlShape = function(m, q) {
      var intx0, intyW;
      intyW = m * width + q;
      intx0 = -q / m;
      ctx.beginPath();
      ctx.moveTo(width, Math.min(intyW, height));
      ctx.lineTo(width, 0);
      ctx.lineTo(Math.max(intx0, 0), 0);
      if (intx0 < 0) {
        ctx.lineTo(0, Math.min(q, height));
        if (q < height) {
          ctx.lineTo((height - q) / m, height);
        }
        return ctx.lineTo(width, height);
      } else {
        if (intyW < height) {
          return ctx.lineTo(width, intyW);
        } else {
          ctx.lineTo((height - q) / m, height);
          return ctx.lineTo(width, height);
        }
      }
    };
    return draw = function() {
      var d, gradient, img, int2x, int2y, intx, inty, m, m2, q, q2, r, stopHighlight, sx, sy, tx, ty;
      if (!init) {
        return;
      }
      ctx.fillStyle = background;
      ctx.fillRect(0, 0, width, height);
      img = sections[0];
      r = $(img).data("flip.scale");
      ctx.drawImage(img, (width - img.width * r) / 2, (height - img.height * r) / 2, img.width * r, img.height * r);
      if (mY && mX !== width) {
        m = 2;
        q = (mY - m * (mX + width)) / 2;
        m2 = mY / (width - mX);
        q2 = mX * m2;
        if (m === m2) {
          return;
        }
        sx = 1;
        sy = 1;
        tx = 0;
        ty = 0;
        ctx.save();
        if (sideLeft) {
          tx = width;
          sx = -1;
        }
        if (!cornersTop) {
          ty = height;
          sy = -1;
        }
        ctx.translate(tx, ty);
        ctx.scale(sx, sy);
        intx = (q2 - q) / (m - m2);
        inty = m * intx + q;
        int2x = (2 * inty + intx + 2 * m * mX - 2 * mY) / (2 * m + 1);
        int2y = -int2x / m + inty + intx / m;
        d = Math.sqrt(Math.pow(intx - int2x, 2) + Math.pow(inty - int2y, 2));
        stopHighlight = Math.min(d * 0.5, 30);
        c = ctx;
        gradient = c.createLinearGradient(intx, inty, int2x, int2y);
        gradient.addColorStop(0, gradientColors[0]);
        gradient.addColorStop(stopHighlight / d, gradientColors[1]);
        gradient.addColorStop(1, gradientColors[2]);
        c.fillStyle = gradient;
        c.beginPath();
        c.moveTo(-q / m, 0);
        c.quadraticCurveTo((-q / m + mX) / 2 + 0.02 * mX, mY / 2, mX, mY);
        c.quadraticCurveTo((width + mX) / 2, (m * width + q + mY) / 2 - 0.02 * (height - mY), width, m * width + q);
        c.fill();
        gradient = null;
        ctx.fillStyle = background;
        curlShape(m, q);
        ctx.fill();
        curlShape(m, q);
        if (!$.browser.safari && !$.browser.opera) {
          ctx.restore();
        }
        img = sideLeft ? sections[sections.length - 1] : sections[1];
        r = $(img).data("flip.scale");
        ctx.save();
        ctx.clip();
        ctx.drawImage(img, (width - img.width * r) / 2, (height - img.height * r) / 2, img.width * r, img.height * r);
        return ctx.restore();
      }
    };
  };

  return PageFlip;

})();

//# sourceMappingURL=pageflip.js.map
