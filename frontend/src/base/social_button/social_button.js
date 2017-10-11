/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const ready = function() {

  // Facebook
  loadFacebookSDK();
  if(!fb_events_bound) {
    bindFacebookEvents();
  }

  // Google
  loadGoogleSDK();
  //gapi.plusone.go()

  // Twitter
  loadTwitterSDK();
  if(!twttr_events_bound) {
    bindTwitterEventHandlers();
  }

  // Pocket
  return loadPocketSDK();
};

// For turbolinks
$(document).ready(ready);
$(document).on('page:load', ready);

// ----------------------------------------- #
// Facebook
// ----------------------------------------- #

let fb_root = null;
var fb_events_bound = false;

var bindFacebookEvents = function() {
  $(document)
  .on('page:fetch', saveFacebookRoot)
  .on('page:change', restoreFacebookRoot)
  .on('page:load', () => typeof FB !== 'undefined' && FB !== null ? FB.XFBML.parse() : undefined);
  return fb_events_bound = true;
};

var saveFacebookRoot = () => fb_root = $('#fb-root').detach();

var restoreFacebookRoot = function() {
  if($('#fb-root').length > 0) {
    return $('#fb-root').replaceWith(fb_root);
  } else {
    return $('body').append(fb_root);
  }
};

var loadFacebookSDK = function() {
  window.fbAsyncInit = initializeFacebookSDK;
  return $.getScript("//connect.facebook.net/ja_JP/all.js#xfbml=1");
};

var initializeFacebookSDK = () =>
  FB.init({
    appId: serverenv.OMNIAUTH_FACEBOOK_KEY,
    channelUrl: `${document.domain}/sb/fb_channel.html`,
    status: true,
    cookie: true,
    xfbml: true
  })
;

// ----------------------------------------- #
// Twitter
// ----------------------------------------- #

var twttr_events_bound = false;

var bindTwitterEventHandlers = function() {
  $(document).on('page:load', renderTweetButtons);
  return twttr_events_bound = true;
};

var renderTweetButtons = function() {
  $('.twitter-share-button').each(function() {
    const button = $(this);
    if(button.data('url') === null) {
      button.attr('data-url', document.location.href);
    }
    if(button.data('text') === null) {
      return button.attr('data-text', document.title);
    }
  });
  return twttr.widgets.load();
};

var loadTwitterSDK = () => $.getScript("//platform.twitter.com/widgets.js");

// ----------------------------------------- #
// Google
// ----------------------------------------- #

var loadGoogleSDK = () => $.getScript("https://apis.google.com/js/plusone.js");

// ----------------------------------------- #
// Pocket
// ----------------------------------------- #

var loadPocketSDK = () => $.getScript("https://widgets.getpocket.com/v1/j/btn.js?v=1");