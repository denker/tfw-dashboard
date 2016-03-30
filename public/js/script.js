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

function calcStepValue(n) {
  var i = 0, m = n, diffs = [];
  while (m >= 1) { m = m/10; i++; } // i = digits in n
  m = m * 10; // we need m greater than one
  const baseValue = ((m * 1.1 / 6) + (m * 1.2 / 9)) / 2; //magic multiplicators and dividors to make a base scale value
  const scaleValues = [0.125, 0.25, 0.5, 1]; // array where we pick a scale value
  scaleValues.forEach( function(e,i,array){ diffs.push(Math.abs(e-baseValue)) });
  var closestValueIndex = diffs.findIndex(function(e,i,array){return e == Math.min.apply(Math, array)}); // which scaleValue item is most closest to base value?
  return scaleValues[closestValueIndex] * Math.pow(10,i-1);
}

if ($('canvas#dayRevenueChart').length) {
  var arr = window.location.href.split('/');
  var range = arr[arr.length-2];
  $.getJSON( "/data.json/"+range, function(data) {

    // calculate custom Y-axis scale
    var max = Math.max.apply(Math, data['datasets'][0]['data']);
    var stepValue = calcStepValue(max);
    var stepsNumber = 0, topPlanc = 0;
    while (topPlanc < max) { topPlanc += stepValue; stepsNumber += 1; }

    var ctx = document.getElementById("dayRevenueChart").getContext("2d");
    var myBarChart = new Chart(ctx).Bar(data, {
      scaleShowVerticalLines: false,
      scaleOverride: true,
      scaleSteps: stepsNumber,
      scaleStepWidth: stepValue,
      scaleStartValue: 0});
  });
}
