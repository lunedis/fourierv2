# Sand-Signika theme for Highcharts JS
# @author Torstein Honsi


Highcharts.theme =
  #colors: ["#f45b5b", "#8085e9", "#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
  #  "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
  colors: ['#FF3333', '#66FF66', '#6666FF', '#FFFF66', '#FFAA66', '#CC6666', '#229922', '#66CCFF']
  chart:
    backgroundColor: null
    style:
      fontFamily: "Verdana, sans-serif"
  title:
    style:
      color: 'black'
      fontSize: '16px'
      fontWeight: 'bold'
  subtitle:
    style:
      color: 'black'
  tooltip:
    borderWidth: 0
  legend:
    itemStyle:
      color: 'white',
      fontWeight: '',
      fontSize: '13px'
  xAxis:
    labels:
      style:
        color: '#6e6e70'
  yAxis:
    gridLineColor: '#666666'
    labels:
      style:
        color: '#6e6e70'
  plotOptions:
    series:
      shadow: true
    candlestick:
      lineColor: '#404048'
    map:
      shadow: false
  # Highstock specific
  navigator:
    xAxis:
      gridLineColor: '#D0D0D8'
  rangeSelector:
    buttonTheme:
      fill: 'white'
      stroke: '#C0C0C8'
      'stroke-width': 1
      states:
        select:
          fill: '#D0D0D8'
  scrollbar:
    trackBorderColor: '#C0C0C8'

  # General
  background2: '#E0E0E8'

# Apply the theme
Highcharts.setOptions Highcharts.theme