
function gotoNewDate(newDate) {
  window.location.href = '/calendar?date=' + newDate;
}

$(function () {

  $("#calendar-month-selector").on("change", function() {
    var selectedDate = $("#calendar-month-selector").val();
    gotoNewDate(selectedDate);
  });
});
