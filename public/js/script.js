$('input[type="text"]').click(function(){this.select();})

$('.row').click( function() {
  // simulates click on edit button when clicked on visit row
  if (this.className.indexOf("danger") == -1) {
    window.location.href = "/visits/" + this.id + "/";
  } } )
