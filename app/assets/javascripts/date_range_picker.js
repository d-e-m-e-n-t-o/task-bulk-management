var date_range_picker;
date_range_picker = function() {
  $('.date-range-picker').each(function(){
    $(this).daterangepicker({
        // timePicker: true,
        // timePickerIncrement: 30,
        alwaysShowCalendars: true
    }, function(start, end, label) {
      $('.start_hidden').val(start.format('YYYY/MM/DD'));
      $('.end').val(end.format('YYYY/MM/DD'));
    });
  })
};
$(document).on('turbolinks:load', date_range_picker);
