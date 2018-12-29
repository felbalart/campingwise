

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

function addReserveForm() {
  if(typeof(window.reserveCount) === 'undefined') { window.reserveCount = 1; }
  window.reserveCount += 1;
  var newFormIndex = window.reserveCount;
  var newFormHtml = $('.hidden-reserve-form-mold').html().replace(/reserve1/g, ('reserve' + newFormIndex));
  newFormHtml = newFormHtml.replace('Reserva 1', ('Reserva ' + newFormIndex));
  $('.visible-reserve-forms-container').append(newFormHtml);
}

$(function () {
  $("#order_guest_id_input").on("change", function() {
    var selectedGuestId = $("#order_guest_id_input select").val();
    updateGuestData(selectedGuestId);
  });

  $('.datepicker').datepicker({
      dateFormat: 'dd/mm/yy'
  });
});

