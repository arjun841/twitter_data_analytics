//= require jquery
//= require jquery_ujs
//= require back/plugins/bootstrap/bootstrap.min
//= require back/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min
//= require back/plugins/datatables/jquery.dataTables.min
//= require back/plugins/jvectormap/jquery-jvectormap-1.2.2.min
//= require back/plugins/jvectormap/jquery-jvectormap-world-mill-en
//= require back/plugins/datatables/dataTables.bootstrap.min
//= require back/plugins/flot/jquery.flot.js
//= require back/plugins/flot/jquery.flot.errorbars.js
//= require back/plugins/flot/jquery.flot.stack.js
//= require back/plugins/flot/jquery.flot.categories.js
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
        fill: '#f56954',
        stroke: '#383f47'
      }
    },
    backgroundColor: '#383f47',
    markers: [
      {latLng: [47.14, 9.52], name: 'Liechtenstein'},
      {latLng: [-4.61, 55.45], name: 'Seychelles'},
      {latLng: [26.02, 50.55], name: 'Bahrain'},
      {latLng: [36.02, 56.55], name: 'Iran'},
      {latLng: [35.02, 64.55], name: 'Afghanistan'},
      {latLng: [35.02, 66.55], name: 'Afghanistan'},
      {latLng: [33.02, 66.55], name: 'Afghanistan'},
      {latLng: [33.02, -80.55], name: 'USA'}
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
        var z = typeof(total_line_chart_data) == "undefined" ? "" : total_line_chart_data[item.datapoint[0]];
        $('#line-chart-tooltip').html('<strong> ' + item.series.label + '#' + z + '</strong> <br>' + 'DATE(' + x + ')<br>COUNT(' + y + ')')
          .css({
            top : item.pageY + 10,
            left: item.pageX + 10
          })
          .fadeIn(200)
      } else {
        $('#line-chart-tooltip').hide()
      }
    });

    function labelFormatter(label, series) {
      return '<div style="font-size:13px; text-align:center; padding:2px; color: #fff; font-weight: 600;">'
        + label
        + '<br>'
        + Math.round(series.percent) + '%</div>'
    }
});
