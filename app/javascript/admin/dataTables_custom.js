$(document).ready(function () {
    // Reusable function to initialize DataTable
    function initializeDataTable(selector) {
        $(selector).DataTable({
            responsive: true,
            autoWidth: false,
            pageLength: 10,
            lengthChange: true,
            order: [[0, 'asc']],
            language: {
                search: 'Filter records:',
                lengthMenu: 'Show _MENU_ entries',
                info: 'Showing _START_ to _END_ of _TOTAL_ entries',
                paginate: {
                    first: 'First',
                    last: 'Last',
                    next: 'Next',
                    previous: 'Previous',
                },
            },
        });
    }

    // List of table IDs
    const tableIds = ['#properties-table', '#all-properties-table', '#all-customers-table', '#all-invoices-table'];

    tableIds.forEach(function (tableId) {
        initializeDataTable(tableId);
    });
});
