Highcharts.theme = {
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: 0,
        plotShadow: false,
        style: {
            fontFamily: "\"Helvetica Neue\", Helvetica, Arial, sans-serif",
            fontWeight: 'normal',
            fontSize: '12px'
        }
    },
    title: {
        style: {
            color: 'black',
            fontWeight: "bold",
            fontSize: "16px"
        }
    },
    subtitle: {
        style: {
            color: '#666666',
            fontSize: "10px"
        }
    },
    legend: {
        enabled: true,
        borderWidth: '0px'
    },
    xAxis: {
        labels: {
            style: {
                fontSize: '11px'
            }
        }
    },
    plotOptions: {
        pie: {
            dataLabels: {
                enabled: true,
                distance: 15,
                connectorColor: '#000000',
                useHTML: true,
                style: {
                    fontWeight: 'normal',
                    fontSize: '12px',
                    color: 'black'
                }
            }
        },
        column: {
            dataLabels: {
                enabled: true,
                inside: false,
                distance: 0,
                zIndex: 99,
                format: '<span style="color:{point.color}">{point.y} %</span>',
                connectorColor: '#000000',
                useHTML: true,
                style: {
                    fontWeight: 'bold',
                    fontSize: '12px'
                }
            }
        },
        series: {
            events: {
                legendItemClick: function(event) {
                    return false;
                }
            }
        }
    },
    credits: {
        enabled: false
    }
};

// Apply the theme
Highcharts.setOptions(Highcharts.theme);