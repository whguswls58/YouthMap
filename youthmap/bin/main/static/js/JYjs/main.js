$(document).ready(function () {
    const $navbar = $('.navbar');
    const $dropdown = $('.mega-dropdown');

    $navbar.hover(
      function () {
        $dropdown.stop(true, true).slideDown(200);
      },
      function () {
        setTimeout(() => {
          if (!$dropdown.is(':hover')) {
            $dropdown.stop(true, true).slideUp(200);
          }
        }, 300);
      }
    );

    $dropdown.hover(
      function () {
        $(this).stop(true, true).show();
      },
      function () {
        $(this).stop(true, true).slideUp(200);
      }
    );
  });