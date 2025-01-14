
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';


console.log('admin_calendar.js loaded');
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM fully loaded');
    const calendarEl = document.getElementById('calendar');
    if (calendarEl) {
        console.log('Calendar element found');
        const calendar = new Calendar(calendarEl, {
            plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
            initialView: 'dayGridMonth',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,listMonth',
            },
            events: '/admin_panel/bookings/calendar_data',
        });
        calendar.render();
        console.log('Calendar rendered');
    } else {
        console.log('Calendar element not found');
    }
});
