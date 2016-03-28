$('.editable').click( function() {
  // simulates click on edit button when clicked on visit row
  if (this.className.indexOf("danger") == -1) {
    window.location.href = "/visits/" + this.id + "/";
  }
})

// add new record when press enter
Mousetrap.bind('enter', function(e) {
  if (/\/visits/.test(document.URL)) {
    if (/\/visits\/\d+/.test(document.URL)) {
      console.log('binded save-visit-button')
      document.getElementById("save-visit-button").click();
    } else {
      console.log('binded add-visit form')
      document.getElementById("add-visit").submit();
    }
  }
});

$('#filter_dates').click( function() {
  if ($('#dates_range').length > 0) {
    var dates = $('#dates_range').val().split(' - ');
    window.location.href = "/history/" + dates[0] + "/to/" + dates[1] + "/";
  }
})

$('#download_visits').click( function() {
  if ($('#dates_range').length > 0) {
    var dates = $('#dates_range').val().split(' - ');
    window.location.href = "/download/" + dates[0] + "/to/" + dates[1] + "/";
  }
})


$('#date-separator-control-checked').click( function() {
  $('#date-separator-control-checked').css("display", "none");
  $('#date-separator-control-unchecked').css("display", "inline-block");
  $('.date-separator').css("display", "none");
  $('.nothing-found').css("display", "none");
});

$('#date-separator-control-unchecked').click( function() {
  $('#date-separator-control-unchecked').css("display", "none");
  $('#date-separator-control-checked').css("display", "inline-block");
  $('.date-separator').css("display", "block");
  $('.nothing-found').css("display", "block");
});

if ($('canvas#dayRevenueChart').length) {
  var arr = window.location.href.split('/');
  var range = arr[arr.length-2];
  $.getJSON( "/data.json/"+range, function(data) {
    var ctx = document.getElementById("dayRevenueChart").getContext("2d");
    var myBarChart = new Chart(ctx).Bar(data, {scaleShowVerticalLines: false});
  });
}
