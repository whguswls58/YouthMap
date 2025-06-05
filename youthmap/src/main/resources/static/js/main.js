// main.js

$(document).ready(function() {
    // 슬라이더 자동 넘김
    let currentIndex = 0;
    const slides = $('.slide');
    const totalSlides = slides.length;

    function showSlide(index) {
        $('.slider').css('transform', 'translateX(' + (-index * 100) + '%)');
    }

    setInterval(function() {
        currentIndex = (currentIndex + 1) % totalSlides;
        showSlide(currentIndex);
    }, 3000);

    // 카테고리 탭 선택
    $('.tab').click(function() {
        $('.tab').removeClass('active');
        $(this).addClass('active');

        const category = $(this).text();
        let subcategories = [];

        if (category === '정책') {
            subcategories = ['지원', '주거', '혜택'];
        } else if (category === '문화') {
            subcategories = ['뮤지컬/연극', '전시회/미술관', '대회/축제'];
        } else if (category === '맛집') {
            subcategories = ['강남구', '강북구', '강서구', '강동구'];
        } else if (category === '유저 게시판') {
            subcategories = ['유저 게시판'];
        }

        let html = '';
        subcategories.forEach(sc => {
            html += '<div class="subcategory">' + sc + '</div>';
        });
        $('.subcategories').html(html);
    });

    // 드롭다운 전체 연동
    $('.dropdown').hover(function() {
        $('.dropdown-content').hide();
        $(this).find('.dropdown-content').show();
    }, function() {
        $('.dropdown-content').hide();
    });
});