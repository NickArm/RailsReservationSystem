// @fullcalendar/daygrid@6.1.15 downloaded from https://ga.jspm.io/npm:@fullcalendar/daygrid@6.1.15/index.js

import{createPlugin as a}from"@fullcalendar/core/index.js";import{DayGridView as r,TableDateProfileGenerator as d}from"./internal.js";import"@fullcalendar/core/internal.js";import"@fullcalendar/core/preact.js";var e=a({name:"@fullcalendar/daygrid",initialView:"dayGridMonth",views:{dayGrid:{component:r,dateProfileGeneratorClass:d},dayGridDay:{type:"dayGrid",duration:{days:1}},dayGridWeek:{type:"dayGrid",duration:{weeks:1}},dayGridMonth:{type:"dayGrid",duration:{months:1},fixedWeekCount:true},dayGridYear:{type:"dayGrid",duration:{years:1}}}});export{e as default};

