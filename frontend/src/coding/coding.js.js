/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(() =>
  $('.coding.item').ready(function() {
    Navbar.initCodingNavbar();
    return CodingCommon.init();
  })
);