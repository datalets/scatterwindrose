w = 500
h = 300
padding = 30
maxNumber = Math.random()*1000
numDataPoints = 50
dataset = (([Math.round(Math.random()*maxNumber),Math.round(Math.random()*maxNumber)]) for num in [1..numDataPoints])
# console.log dataset

xScale = d3.scale.linear()
	.domain([0, d3.max(dataset,(d)->d[0] )])
	.range([padding, w-padding * 2])


yScale = d3.scale.linear()
	.domain([0, d3.max(dataset, (d)->d[1])])
  .range([h-padding, padding])
    
xAxis = d3.svg.axis()
    		.scale(xScale)
      	.orient("bottom")
        .ticks(5)
        
yAxis = d3.svg.axis()
        .scale(yScale)
        .orient("left")
        .ticks(5)
        
        
svg = d3.select("body")
			.append("svg")
  		.attr(
      			width: w
      			height: h
      )
			
svg.append("clipPath")
	.attr("id","chart-area")
  .append("rect")
  .attr(
    x:padding
    y:padding
    width:w-padding*3
    height:h-padding*2
  )
svg.append("g")
	.attr(
    id:"circles"
    "clip-path":"url(#chart-area)"
  )
	.selectAll("circle")
	.data(dataset)
  .enter()
  .append("circle")
  .attr(
    cx: (d)->xScale(d[0])
    cy: (d)->yScale(d[1])
    r:2 )
  
svg.append("g")
	.attr(
  		class: "x axis"
  		transform: "translate(0,#{h-padding})")
  .call(xAxis)
  
svg.append("g")
	.attr(
  		class: "y axis"
  		transform: "translate(#{padding},0)")
  .call(yAxis)
  
  
  
d3.select("p")
	.on("click", ->
    numValues = dataset.length
    maxNumber = Math.random() * 1000
    dataset = (([Math.round(Math.random()*maxNumber),Math.round(Math.random()*maxNumber)]) for num in [1..numValues])
    
    xScale.domain([0, d3.max(dataset,(d)->d[0])])
    yScale.domain([0, d3.max(dataset,(d)->d[1])])
    
    svg.selectAll("circle")
    	.data(dataset)
      .transition()
      .duration(1000)
      .each("start", ->
        d3.select(@)
        	.attr(
            fill:"magenta"
            r:7
          )
      )
      .attr(
        cx: (d)->xScale(d[0])
        cy: (d)->yScale(d[1]))
    	.each("end", ->
        d3.select(@)
        	.transition()
          .duration(1000)
        	.attr(
            fill:"black"
            r:2
          )
      )
    svg.select(".x.axis")
    	.transition()
      .duration(1000)
      .call(xAxis)
    svg.select(".y.axis")
    	.transition()
      .duration(1000)
      .call(yAxis)
  )
