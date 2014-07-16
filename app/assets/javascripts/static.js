jQuery(document).ready(function($) {
    // Load Google visualization library if a chart element exists
    if ($('[data-chart]').length > 0) {
	google.load('visualization', '1.0', {'packages': ['corechart'], 'callback': function() {
	    $('[data-chart]').each(function () {
		var div = $(this)
		// Fetch chart data
		$.getJSON(div.attr('data-chart'), function(data) {
		    // Create DataTable from received chart data
		    var table = new google.visualization.DataTable();
		    $.each(data.cols, function () { table.addColumn.apply(table, this); });
		    // $.each(data.rows, function() { table.addRow([new Date(this[0]), this[1]]) });
		    $.each(data.rows, function() { table.addRow([this[0], this[1]]) });
		    
		    // Draw the chart
		    var chart = new google.visualization.ChartWrapper();
		    chart.setChartType(data.type);
		    chart.setDataTable(table);
		    chart.setOptions(data.options);
		    chart.setOption('width', div.width());
		    chart.setOption('height', div.height());
		    chart.setOption('vAxis.minValue', 1);
		    chart.setOption('vAxis.maxValue', 3);
		    chart.setOption('vAxis.format', 'OT #');
		    chart.draw(div.get(0));
		});
	    });
	}});
    }
});

//          ["Jan 1, 2012 19:43:37", 1],