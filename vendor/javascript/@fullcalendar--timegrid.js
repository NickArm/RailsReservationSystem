// @fullcalendar/timegrid@6.1.15 downloaded from https://ga.jspm.io/npm:@fullcalendar/timegrid@6.1.15/index.js

import{createPlugin as e}from"@fullcalendar/core/index.js";import{DayTimeColsView as r}from"./internal.js";import"@fullcalendar/core/internal.js";import"@fullcalendar/core/preact.js";import"@fullcalendar/daygrid/internal.js";const i={allDaySlot:Boolean};var t=e({name:"@fullcalendar/timegrid",initialView:"timeGridWeek",optionRefiners:i,views:{timeGrid:{component:r,usesMinMaxTime:true,allDaySlot:true,slotDuration:"00:30:00",slotEventOverlap:true},timeGridDay:{type:"timeGrid",duration:{days:1}},timeGridWeek:{type:"timeGrid",duration:{weeks:1}}}});export{t as default};

