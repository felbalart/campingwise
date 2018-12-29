

function updateGuestData(guestId) {
  if(guestId > 0) {
    $("#order_guest_id_input .select2").addClass('existing-guest');
    var data = window.guestsData[guestId];
    $('#order_guest_name').val(data.name);
    $('#order_guest_email').val(data.email);
    $('#order_guest_phone').val(data.phone);
  }
  else {
    $("#order_guest_id_input .select2").removeClass('existing-guest');
    $('#order_guest_email').val('')
  }
}

$(function () {
  $("#order_guest_id_input").on("change", function() {
    var selectedGuestId = $("#order_guest_id_input select").val();
    updateGuestData(selectedGuestId);
  });
});

