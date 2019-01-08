

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
  newForm.find('.site-select2').change(function () {
    setupBaseFee(newFormIndex);
  });
  newForm.find('.base_fee-select2').change(function () {
    setupBaseFee(newFormIndex);
  });
  newForm.find('.reserve-date-input').datepicker({
    dateFormat: 'dd/mm/yy'
  });

  newForm.find('.reserve-price-related-input').change(function () {
    setPriceInputs();
  });

  newForm.find('.reserve-price-direct-input').change(function () {
    moveToCustom(newFormIndex);
  });

  newForm.find('.reserve-date-input').change(function () {
    setUpNightsInput();
    setPriceInputs();
  });
  setUpNightsInput();
  setupBaseFee(newFormIndex);
  return newFormIndex;
}

function populateReserveForm(reserveData, formIndex) {
  $('#order_reserve' + formIndex + '_id').val(reserveData.id);
  $('#order_reserve' + formIndex + '_site_id').val(reserveData.site_id).trigger('change');
  var start_date_val = (reserveData.start_date !== null) ? formatDateDBtoCL(reserveData.start_date) : '';
  $('#order_reserve' + formIndex + '_start_date').val(start_date_val);
  var end_date_val = (reserveData.end_date !== null) ? formatDateDBtoCL(reserveData.end_date) : '';
  $('#order_reserve' + formIndex + '_end_date').val(end_date_val);
  $('#order_reserve' + formIndex + '_adults_qty').val(reserveData.adults_qty);
  $('#order_reserve' + formIndex + '_kids_qty').val(reserveData.kids_qty);
  if(reserveData.fix_total_night_price !== null) { $('#order_reserve' + formIndex + '_fix_total_night_price')[0].checked = reserveData.fix_total_night_price; }
  if(reserveData.adult_price !== null) { $('#order_reserve' + formIndex + '_adult_price').val(reserveData.adult_price); }
  if(reserveData.kid_price !== null) { $('#order_reserve' + formIndex + '_kid_price').val(reserveData.kid_price); }
  if(reserveData.total_night_price !== null) { $('#order_reserve' + formIndex + '_total_night_price').val(reserveData.total_night_price); }
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

function clStrToDate(dateClStr) {
  var day = dateClStr.substring(0,2);
  var month = dateClStr.substring(3,5);
  var year = dateClStr.substring(6,10);
  return new Date(year + '-' + month + '-' + day);
}

function setPriceInputs() {
  if(typeof(window.reserveCount) === 'undefined') { window.reserveCount = 0; }
  var ri = 0;
  for (ri = 0; ri <= window.reserveCount; ri++) {
    if ($('#order_reserve' + ri + '_fix_total_night_price').length === 0) { continue; }
    var priceFixed = $('#order_reserve' + ri + '_fix_total_night_price')[0].checked;
    $('#order_reserve' + ri + '_adult_price').toggleClass('disabled-input', priceFixed);
    $('#order_reserve' + ri + '_kid_price').toggleClass('disabled-input', priceFixed);
    $('#order_reserve' + ri + '_total_night_price').toggleClass('disabled-input', !priceFixed);
    $('#order_reserve' + ri + '_adult_price').prop('disabled', priceFixed);
    $('#order_reserve' + ri + '_kid_price').prop('disabled', priceFixed);
    $('#order_reserve' + ri + '_total_night_price').prop('readonly', !priceFixed);
    var total_night_price;
    if(priceFixed) {
      $('#order_reserve' + ri + '_adult_price').val('');
      $('#order_reserve' + ri + '_kid_price').val('');
      total_night_price = $('#order_reserve' + ri + '_total_night_price').val();
    } else {
      var adults = $('#order_reserve' + ri + '_adults_qty').val();
      var kids = $('#order_reserve' + ri + '_kids_qty').val();
      var adults_price = $('#order_reserve' + ri + '_adult_price').val();
      var kids_price = $('#order_reserve' + ri + '_kid_price').val();
      total_night_price = (adults * adults_price) + (kids * kids_price);
      $('#order_reserve' + ri + '_total_night_price').val(total_night_price);
    }
    var total_nights = getTotalNights(ri);
    var total_final_price = total_night_price * total_nights;
    $('#order_reserve' + ri + '_total_final_price').val(total_final_price);
  }
}

function setUpNightsInput() {
  if(typeof(window.reserveCount) === 'undefined') { window.reserveCount = 0; }
  var ri = 0;
  for (ri = 0; ri <= window.reserveCount; ri++) {
    var nights = getTotalNights(ri);
    $('#order_reserve' + ri + '_nights_long').val(nights);
  }
}

function getTotalNights(formIndex) {
  var startDateStr = $('#order_reserve' + formIndex + '_start_date').val();
  var endDateStr =  $('#order_reserve' + formIndex + '_end_date').val();
  var nights;
  if(startDateStr.length !== 10 || endDateStr.length !== 10) { nights = 0; }
  else {
    var startDate = clStrToDate(startDateStr);
    var endDate = clStrToDate(endDateStr);
    nights = Date.daysBetween(startDate, endDate) + 1;
  }
  if(nights < 0) { nights = 0; }
  return nights;
}


function setupBaseFee(ri) {
  var id = parseInt($('#order_reserve' + ri + '_id').val());
  var siteId = parseInt($('#order_reserve' + ri + '_site_id').val());
  if(!isNaN(id) || isNaN(siteId)) { // will return if reserve has id or site has not been chosen
    hideBaseFeeExcept(ri, null);
    return;
  }
  var siteCategoryData = $('#reserves-data-container').data().siteCategories;
  var siteCategory = siteCategoryData[siteId];
  hideBaseFeeExcept(ri, siteCategory);

  var currentBaseFee = $('#order_reserve' + ri + '_' + siteCategory + '_fee').val();
  if(currentBaseFee === 'custom') {
    return;
  }
  var fee;
  if(currentBaseFee === '') {
    fee = findDefaultBaseFee(siteCategory);
    if(typeof(fee) !== 'object') { return; }
    $('#order_reserve' + ri + '_' + siteCategory + '_fee').val(fee.id).trigger('change.select2');
  } else {
    var baseFees = $('#reserves-data-container').data().fees;
    fee = baseFees[parseInt(currentBaseFee)];
  }
  if(typeof(fee) !== 'object') { return; }
  loadBaseFeeValues(ri, fee);
}

function loadBaseFeeValues(ri, fee) {
  $('#order_reserve' + ri + '_adult_price').val(fee.adult_price);
  $('#order_reserve' + ri + '_kid_price').val(fee.kid_price);
  $('#order_reserve' + ri + '_total_night_price').val(fee.total_night_price);
  $('#order_reserve' + ri + '_fix_total_night_price').prop('checked', fee.site_category !== 'campsite');
  setPriceInputs();
}

// DEPRECATED
// Llamar cada vez que hay un cambio de instalación y no hay id y la tarifa no es custom
// function loadBaseFee(ri) {
//   $('.reserve' + ri + '-fee').closest('li.select.input').hide();
//   var siteId = parseInt($('#order_reserve' + ri + '_site_id').val());
//   if(typeof(siteId) !== 'number') { return; }
//   var siteCategoryData = $('#reserves-data-container').data().siteCategories;
//   var siteCategory = siteCategoryData[siteId];
//   $('#order_reserve' + ri + '_' + siteCategory + '_fee_input').show();
//   var fee = findDefaultBaseFee(siteCategory);
//   if(typeof(fee) !== 'object') { return; }
//   $('#order_reserve' + ri + '_' + siteCategory + '_fee').val(fee.id).trigger('change');
// }

function hideBaseFeeExcept(ri, siteCategory) {
  $('.reserve' + ri + '-fee').closest('li.select.input').hide();
  $('.reserve' + ri + '-fee').removeClass('active-base-fee-select2');
  if(typeof(siteCategory) !== 'string') { return; }
  $('#order_reserve' + ri + '_' + siteCategory + '_fee_input').show(); // if siteCategory null, all will be hidden
}

function moveToCustom(ri) {
  var siteId = parseInt($('#order_reserve' + ri + '_site_id').val());
  var siteCategoryData = $('#reserves-data-container').data().siteCategories;
  var siteCategory = siteCategoryData[siteId];
  $('#order_reserve' + ri + '_' + siteCategory + '_fee').val('custom').trigger('change');
}

function findDefaultBaseFee(siteCategory) {
  var baseFeesArray = Object.values($('#reserves-data-container').data().fees);
  var bf_i = 0;
  for (bf_i = 0; bf_i < baseFeesArray.length; bf_i++) {
    var fee = baseFeesArray[bf_i];
    if (fee.site_category === siteCategory && fee.default_fee) {
      return fee;
    }
  }
}


$(function () {
  if($('.hidden-reserve-form-mold').length === 0) { return; } // abort if current view is not main-form
  else {
    loadReserves();
    setUpNightsInput();
    setPriceInputs();
  }

  $("#order_guest_id_input").on("change", function() {
    var selectedGuestId = $("#order_guest_id_input select").val();
    updateGuestData(selectedGuestId);
  });

  $('.datepicker').datepicker({
      dateFormat: 'dd/mm/yy'
  });
});

/// src https://www.quora.com/How-do-I-get-the-number-of-days-between-two-dates-in-Javascript
Date.daysBetween = function( date1, date2 ) {   //Get 1 day in milliseconds
  var one_day=1000*60*60*24;    // Convert both dates to milliseconds
  var date1_ms = date1.getTime();
  var date2_ms = date2.getTime();    // Calculate the difference in milliseconds
  var difference_ms = date2_ms - date1_ms;        // Convert back to days and return
  return Math.floor(difference_ms/one_day);
};
