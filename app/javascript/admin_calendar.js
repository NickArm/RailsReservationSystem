import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';

document.addEventListener('DOMContentLoaded', () => {
    const calendarEl = document.getElementById('calendar');
    if (calendarEl) {
        const calendar = new Calendar(calendarEl, {
            plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
            initialView: 'dayGridMonth',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,listMonth',
            },
            events: '/admin/bookings/calendar_data',
            views: {
                dayGridTwoMonths: {
                    type: 'dayGrid',
                    duration: { months: 2 },
                    buttonText: '2 Months',
                },
            },
            initialView: 'dayGridTwoMonths',
        });
        calendar.render();
    } else {
        console.log('Calendar element not found');
    }
});
