

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
  newForm.find('input[type=checkbox]').change(function () {
    setPriceInputs();
  });
  return newFormIndex;
}

function populateReserveForm(reserveData, formIndex) {
  $('#order_reserve' + formIndex + '_id').val(reserveData.id);
  $('#order_reserve' + formIndex + '_site_id').select2('val', ('' + reserveData.site_id));
  var start_date_val = (reserveData.start_date !== null) ? formatDateDBtoCL(reserveData.start_date) : '';
  $('#order_reserve' + formIndex + '_start_date').val(start_date_val);
  var end_date_val = (reserveData.end_date !== null) ? formatDateDBtoCL(reserveData.end_date) : '';
  $('#order_reserve' + formIndex + '_end_date').val(end_date_val);
  $('#order_reserve' + formIndex + '_adults_qty').val(reserveData.adults_qty);
  $('#order_reserve' + formIndex + '_kids_qty').val(reserveData.kids_qty);
  $('#order_reserve' + formIndex + '_fix_total_price')[0].checked = reserveData.fix_total_price;
  $('#order_reserve' + formIndex + '_adult_price').val(reserveData.adult_price);
  $('#order_reserve' + formIndex + '_kid_price').val(reserveData.kid_price);
  $('#order_reserve' + formIndex + '_total_price').val(reserveData.total_price);
}

function loadReserves() {
  var reserves = $('#reserves-data-container').data().reserves;
  if(reserves.length === 0) {
    addReserveForm();
    return;
  }
  var ri = 0;
  for (ri = 0; ri < reserves.length; ri++) {
    var newFormIndex = addReserveForm();
    populateReserveForm(reserves[ri], newFormIndex);
  }
}

function formatDateDBtoCL(dateDbStr) {
  var day = dateDbStr.substring(8,10);
  var month = dateDbStr.substring(5,7);
  var year = dateDbStr.substring(0,4);
  return day + '/' + month + '/' + year;
}

function setPriceInputs() {
  if(typeof(window.reserveCount) === 'undefined') { window.reserveCount = 0; }
  var ri = 0;
  for (ri = 0; ri <= window.reserveCount; ri++) {
    if ($('#order_reserve' + ri + '_fix_total_price').length === 0) { continue; }
    var priceFixed = $('#order_reserve' + ri + '_fix_total_price')[0].checked;
    $('#order_reserve' + ri + '_adult_price').toggleClass('disabled-input', priceFixed);
    $('#order_reserve' + ri + '_kid_price').toggleClass('disabled-input', priceFixed);
    $('#order_reserve' + ri + '_total_price').toggleClass('disabled-input', !priceFixed);
    $('#order_reserve' + ri + '_adult_price').prop('disabled', priceFixed);
    $('#order_reserve' + ri + '_kid_price').prop('disabled', priceFixed);
    $('#order_reserve' + ri + '_total_price').prop('readonly', !priceFixed);
    if(priceFixed) {
      $('#order_reserve' + ri + '_adult_price').val('');
      $('#order_reserve' + ri + '_kid_price').val('');
    } else {
      var adults = $('#order_reserve' + ri + '_adults_qty').val();
      var kids = $('#order_reserve' + ri + '_kids_qty').val();
      var adults_price = $('#order_reserve' + ri + '_adult_price').val();
      var kids_price = $('#order_reserve' + ri + '_kid_price').val();
      var total_price = (adults * adults_price) + (kids * kids_price);
      $('#order_reserve' + ri + '_total_price').val(total_price);
    }
  }
}

$(function () {
  if($('.hidden-reserve-form-mold').length === 0) { return; } // abort if current view is not main-form
  else {
    loadReserves();
    setPriceInputs();
  }

  $('.reserve-price-related-input').change(function () {
    setPriceInputs();
  });

  $("#order_guest_id_input").on("change", function() {
    var selectedGuestId = $("#order_guest_id_input select").val();
    updateGuestData(selectedGuestId);
  });

  $('.datepicker').datepicker({
      dateFormat: 'dd/mm/yy'
  });
});
