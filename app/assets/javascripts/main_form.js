

function updateGuestData(guestId) {
  var data = window.guestsData[guestId];
  $('#order_guest_name').val(data.name);
  if(guestId > 0) {
    $("#order_guest_id_input .select2").addClass('existing-guest');
    $('#order_guest_email').val(data.email);
    $('#order_guest_phone').val(data.phone);
  }
  else {
    $("#order_guest_id_input .select2").removeClass('existing-guest');
    $('#order_guest_email').val('');
    $('#order_guest_phone').val('');
  }
}

function addReserveForm() {
  if(typeof(window.reserveCount) === 'undefined') { window.reserveCount = 0; }
  window.reserveCount += 1;
  var newFormIndex = window.reserveCount;
  var newFormHtml = $('.hidden-reserve-form-mold').html().replace(/reserve0/g, ('reserve' + newFormIndex));
  newFormHtml = newFormHtml.replace('Reserva 0', ('Reserva ' + newFormIndex));
  var newForm = $(newFormHtml);
  newForm.find("span.select2").remove();
  newForm.find("select").select2();
  newForm.appendTo('.visible-reserve-forms-container');
}

$(function () {
  addReserveForm();

  $("#order_guest_id_input").on("change", function() {
    var selectedGuestId = $("#order_guest_id_input select").val();
    updateGuestData(selectedGuestId);
  });

  $('.datepicker').datepicker({
      dateFormat: 'dd/mm/yy'
  });
});

/// TEMP

function pl() {
  $('#order_guest_name').val('Juan Perez');
  $('#order_guest_email').val('el@email.com');
  $('#order_guest_phone').val('+56 99 9116029711');
  $('#order_tag').val('soyuntag');
  $('#order_reserve1_start_date').val('11/10/2018');
  $('#order_reserve1_end_date').val('19/10/2018');
  $('#order_reserve1_adults_qty').val(7);
  $('#order_reserve1_kids_qty').val(22);
  $('#order_reserve1_adult_price').val(5000);
  $('#order_reserve1_kid_price').val(2500);
  $('#order_reserve1_total_price').val(12200);
  $('#order_reserve2_start_date').val('22/12/2018');
  $('#order_reserve2_end_date').val('25/12/2018');
  $('#order_reserve2_adults_qty').val(2);
  $('#order_reserve2_kids_qty').val(0);
  $('#order_reserve2_adult_price').val(7000);
  $('#order_reserve2_kid_price').val(0);
  $('#order_reserve2_total_price').val(9500);


}