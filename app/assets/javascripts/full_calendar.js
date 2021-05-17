var initialize_calendar; // initialize_calendar変数を定義することで変数を初期化
initialize_calendar = function() {
  $('.calendar').each(function(){ // calendarクラスのそれぞれをeach
    var calendar = $(this); // コールバック内でcalendar変数を使用するため、初期化カレンダーを呼び出してcalendar変数を定義
    calendar.fullCalendar({
      header: { // カレンダーのheader部分を定義
        // left: 'prev,next',
        // center: 'title',
        // right: 'month,agendaWeek,agendaDay'
      },
      // selectable: true, // カレンダーの日を選択できるようにする
      // selectHelper: true, // カレンダーにバーを表示
      // editable: true, // カレンダーのイベントを変更できるようにする
      // eventLimit: true, // 1日に表示されるイベントの数を制限します。残りはポップオーバーに表示されます(イベントが多すぎると、「+ 2more」のようなリンクが表示されます)
      locale: 'ja',
      contentHeight: 'auto',
      events: '/events.json',
      //イベントの色を変える
      eventColor: '#63ceef',
      //イベントの文字色を変える
      eventTextColor: '#000000',

      // select: function(start, end) {
      //   $.getScript('/events/new', function() {
      //     $('.date-range-picker').val(moment(start).format("YYYY/MM/DD") + ' - ' + moment(end).format("YYYY/MM/DD")).
      //     daterangepicker();
      //     $('.start_hidden').val(moment(start).format('YYYY/MM/DD'));
      //     $('.end_hidden').val(moment(end).format('YYYY/MM/DD'));
      //   });

      //   calendar.fullCalendar('unselect');
      // },

      // eventDrop: function(event, delta, revertFunc) {
      //   event_data = {
      //     event: {
      //       id: event.id,
      //       start: event.start.format(),
      //       end: event.end.format()
      //     }
      //   };
      //   $.ajax({
      //       url: event.update_url,
      //       data: event_data,
      //       type: 'PATCH'
      //   });
      // },

      // eventClick: function(event, jsEvent, view) {
      //   $.getScript(event.edit_url, function() {
      //     $('#event_date_range').val(moment(event.start).format("MM/DD/YYYY") + ' - ' + moment(event.end).format("MM/DD/YYYY"))
      //     date_range_picker();
      //     $('.start_hidden').val(moment(event.start).format('YYYY-MM-DD'));
      //     $('.end_hidden').val(moment(event.end).format('YYYY-MM-DD'));
      //   });
      // }
    });
  })
};
$(document).on('turbolinks:load', initialize_calendar); // turbolinksでロード
