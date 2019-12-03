//= require jquery
//= require jquery_ujs
//= require back/plugins/bootstrap/bootstrap.min
//= require back/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min
//= require back/plugins/datatables/jquery.dataTables.min
//= require back/plugins/jvectormap/jquery-jvectormap-1.2.2.min
//= require back/plugins/jvectormap/jquery-jvectormap-world-mill-en
//= require back/plugins/datatables/dataTables.bootstrap.min
//= require back/plugins/flot/jquery.flot.js
//= require back/plugins/flot/jquery.flot.time.min.js
//= require back/plugins/flot/excanvas.js
//= require back/plugins/flot/jquery.flot.symbol.min.js
//= require back/plugins/flot/jquery.flot.resize.js
//= require back/app

$(document).ready(function() {
  var table = $('.dataTable').DataTable();

  // Get sidebar state from localStorage and add the proper class to body
  $('body').addClass(localStorage.getItem('sidebar-state'));

  var activePage = stripTrailingSlash(window.location.pathname);
  $('.sidebar-menu li a').each(function(){
    var currentPage = stripTrailingSlash($(this).attr('href'));
    if (activePage == currentPage) {
      $(this).closest('.treeview').addClass('active');
      $(this).parent().addClass('active');
    }
  });
  function stripTrailingSlash(str) {
    if(str.substr(-1) == '/') { return str.substr(0, str.length - 1); }
    return str;
  }

  // Save sidebar state in localStorage browser
  $('.sidebar-toggle').on('click', function(){
    if($('body').attr('class').indexOf('sidebar-collapse') != -1) {
      localStorage.setItem('sidebar-state', '');
    } else {
      localStorage.setItem('sidebar-state', 'sidebar-collapse');
    }
  });

  $('#world-map-markers').vectorMap({
    map: 'world_mill_en',
    scaleColors: ['#C8EEFF', '#0071A4'],
    normalizeFunction: 'polynomial',
    hoverOpacity: 0.7,
    hoverColor: false,
    markerStyle: {
      initial: {
        fill: '#F8E23B',
        stroke: '#383f47'
      }
    },
    backgroundColor: '#383f47',
    markers: [
      {latLng: [41.90, 12.45], name: 'Vatican City'},
      {latLng: [43.73, 7.41], name: 'Monaco'},
      {latLng: [-0.52, 166.93], name: 'Nauru'},
      {latLng: [-8.51, 179.21], name: 'Tuvalu'},
      {latLng: [43.93, 12.46], name: 'San Marino'},
      {latLng: [47.14, 9.52], name: 'Liechtenstein'},
      {latLng: [7.11, 171.06], name: 'Marshall Islands'},
      {latLng: [17.3, -62.73], name: 'Saint Kitts and Nevis'},
      {latLng: [3.2, 73.22], name: 'Maldives'},
      {latLng: [35.88, 14.5], name: 'Malta'},
      {latLng: [12.05, -61.75], name: 'Grenada'},
      {latLng: [13.16, -61.23], name: 'Saint Vincent and the Grenadines'},
      {latLng: [13.16, -59.55], name: 'Barbados'},
      {latLng: [17.11, -61.85], name: 'Antigua and Barbuda'},
      {latLng: [-4.61, 55.45], name: 'Seychelles'},
      {latLng: [7.35, 134.46], name: 'Palau'},
      {latLng: [42.5, 1.51], name: 'Andorra'},
      {latLng: [14.01, -60.98], name: 'Saint Lucia'},
      {latLng: [6.91, 158.18], name: 'Federated States of Micronesia'},
      {latLng: [1.3, 103.8], name: 'Singapore'},
      {latLng: [1.46, 173.03], name: 'Kiribati'},
      {latLng: [-21.13, -175.2], name: 'Tonga'},
      {latLng: [15.3, -61.38], name: 'Dominica'},
      {latLng: [-20.2, 57.5], name: 'Mauritius'},
      {latLng: [26.02, 50.55], name: 'Bahrain'},
      {latLng: [0.33, 6.73], name: 'São Tomé and Príncipe'}
    ]
  });

  /*
     * LINE CHART
     * ----------
     */
    //LINE randomly generated data
    $.plot('#line-chart', line_chart_data, {
      grid  : {
        hoverable  : true,
        borderColor: '#f3f3f3',
        borderWidth: 1,
        tickColor  : '#f3f3f3'
      },
      series: {
        shadowSize: 0,
        lines     : {
          show: true
        },
        points    : {
          show: true
        }
      },
      lines : {
        fill : false,
        color: ['#3c8dbc', '#f56954']
      },
      yaxis : {
        show: true
      },
      xaxis : {
        mode: "time",
        tickSize: [1, "day"],        
        tickLength: 0,
        axisLabel: "Date",
        axisLabelUseCanvas: true,
        axisLabelFontSizePixels: 12,
        axisLabelFontFamily: 'Verdana, Arial',
        color: "black",
        show: true
      }
    });
    //Initialize tooltip on hover
    $('<div class="tooltip-inner" id="line-chart-tooltip"></div>').css({
      position: 'absolute',
      display : 'none',
      opacity : 0.8
    }).appendTo('body');

    $('#line-chart').bind('plothover', function (event, pos, item) {
      if (item) {
        var currentDate = new Date(item.datapoint[0]);
        var date = currentDate.getDate();
        var month = currentDate.getMonth();
        var year = currentDate.getFullYear();
        var x = date + "-" +(month + 1) + "-" + year;
        var y = item.datapoint[1];
        $('#line-chart-tooltip').html('<strong>' + item.series.label + '</strong> <br>' + '[DATE(' + x + ') : COUNT(' + y + ')]')
          .css({
            top : item.pageY + 5,
            left: item.pageX + 5
          })
          .fadeIn(200)
      } else {
        $('#line-chart-tooltip').hide()
      }
    });
    /* END LINE CHART */
    /*
     * BAR CHART
     * ---------
     */
    // var bar_data = {
    //   data : [[1,10], [2,8], [3,4], [4,13], [5,17], [6,9]],
    //   bars: { show: true }
    // }
    // $.plot('#bar-chart', [bar_data], {
    //   grid  : {
    //     borderWidth: 1,
    //     borderColor: '#f3f3f3',
    //     tickColor  : '#f3f3f3'
    //   },
    //   series: {
    //      bars: {
    //       show: true, barWidth: 0.5, align: 'center',
    //     },
    //   },
    //   colors: ['#3c8dbc'],
    //   xaxis : {
    //     ticks: [[1,'January'], [2,'February'], [3,'March'], [4,'April'], [5,'May'], [6,'June']]
    //   }
    // });
    /* END BAR CHART */
    /*
   * Custom Label formatter
   * ----------------------
   */
    function labelFormatter(label, series) {
      return '<div style="font-size:13px; text-align:center; padding:2px; color: #fff; font-weight: 600;">'
        + label
        + '<br>'
        + Math.round(series.percent) + '%</div>'
    }
});
