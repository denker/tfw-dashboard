$('.row').click( function() {
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
