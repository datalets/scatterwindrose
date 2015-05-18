w = 500
h = 300
padding = 0

d3.select("#updatecache")
  .on("click", ->
    dataset = []
    textarea = d3.select("body").append("textarea")

    loadSnmData = (d) -> 
      dataset.push [st.windDirection, st.windSpeed] for st in d
      textarea.html JSON.stringify dataset

    parseRows = (e, d) -> 
      d3.json 'data/smn/' + f.f.trim(), loadSnmData for f in d

    d3.csv "data/list.csv", ((d) -> return { f: d.filename }), parseRows
  )

svg = d3.select("body")
      .append("svg")
      .attr(
            width: w
            height: h
      )

d3.json 'data/wind.json', (dataset) ->
  # Calculate scales
  xScale = d3.scale.linear()
    .domain([0, d3.max(dataset,(d)->d[0] )])
    .range([padding, w-padding * 2])
  yScale = d3.scale.linear()
    .domain([0, d3.max(dataset, (d)->d[1])])
    .range([h-padding, padding])

  svg.append("g")
    .attr(
      id:"circles"
    )
    .selectAll("circle")
    .data(dataset)
    .enter()
    .append("circle")
    .attr(
      cx: (d)->xScale(d[0])
      cy: (d)->yScale(d[1])
      r:2 )
