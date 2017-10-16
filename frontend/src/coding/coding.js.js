import Navbar from '../navbar/navbar';
import CodingCommon from './coding_common';
$(() =>
  $('.coding.item').ready(function() {
    Navbar.initCodingNavbar();
    return CodingCommon.init();
  })
);
