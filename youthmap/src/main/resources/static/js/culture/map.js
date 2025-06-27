window.addEventListener("DOMContentLoaded", function() {
  if (typeof mapLat === 'undefined' || typeof mapLng === 'undefined') return;
  if (!document.getElementById('map')) return;

  kakao.maps.load(function() {
    var lat = parseFloat(mapLat), lng = parseFloat(mapLng);
    var map = new kakao.maps.Map(
      document.getElementById('map'),
      {
        center: new kakao.maps.LatLng(lat, lng),
        level: 3
      }
    );
    new kakao.maps.Marker({
      position: new kakao.maps.LatLng(lat, lng),
      map: map
    });
  });
});
