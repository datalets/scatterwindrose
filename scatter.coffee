width = window.innerWidth
height = window.innerHeight
padding = 0

svg = d3.select("body")
      .append("svg")
      .attr(
            width:  width
            height: height
            class:  'PuRd'
      )
      .on("click", ->
        if !window.confirm "Reload data?"
          return
        dataset = []
        textarea = d3.select("body").append("textarea")
        svg.attr(style: 'display:none')

        loadSnmData = (d) -> 
          dataset.push [st.windDirection, st.windSpeed, ix] for st, ix in d
          textarea.html JSON.stringify dataset

        parseRows = (e, d) -> 
          d3.json 'data/smn/' + f.f.trim(), loadSnmData for f in d

        d3.csv "data/list.csv", ((d) -> return { f: d.filename }), parseRows
      )

d3.json 'data/windloc.json', (dataset) ->
  xRange = [ d3.min(dataset,(d)->d[0]), d3.max(dataset,(d)->d[0]) ]
  xScale = d3.scale.linear()
    .domain(xRange)
    .range([padding, width-padding * 2])
  yRange = [ d3.min(dataset,(d)->d[1]), d3.max(dataset,(d)->d[1]) ]
  yScale = d3.scale.linear()
    .domain(yRange)
    .range([height-padding, padding])
  zRange = [ d3.min(dataset,(d)->d[2]), d3.max(dataset,(d)->d[2]) ]
  
  dx = width / 2
  dy = height / 2
  
  mult = 2.0 / 57.296 # 1.997
  minima = xRange[1] * 0.5
  multByMin = (amount) -> if amount < minima then 0.0 else 0.003

  xRadial = (delta, amount) -> 10*amount *  Math.sin(3.14 * mult * delta) #+ Math.random()*0.25) * multByMin(amount)
  yRadial = (delta, amount) -> 10*amount * -Math.cos(3.14 * mult * delta) #+ Math.random()*0.25) * multByMin(amount)

  pad = d3.format("05d")
  quantize = d3.scale.quantile().domain(zRange).range(d3.range(9))

  svg.append("g")
    .attr(
      id: "circles"
    )
    .selectAll("circle")
    .data(dataset)
    .enter()
    .append("circle")
    .attr(
      cx: (d) -> xRadial(d[0], d[1]) + dx
      cy: (d) -> yRadial(d[0], d[1]) + dy
      class: (d) ->"q" + quantize(d[2]) + "-9"
      r: 1.6
    )
