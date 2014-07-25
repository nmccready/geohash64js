ns2.namespace 'geohash64'
geohash64.GoogleCoder =
  encode: (value, isZoom) ->
    hash = ''
    value = rounded value unless isZoom
    #      console.log "Rounded value: #{value}"
    #step 2 & 4
    value = maybeFlip value << 1 unless isZoom
    #      console.log "After maybeflip:#{value}"
    #Step 5 - 8
    chunks = getChunks value
    # Step 9-10
    chunks.forEach (c) ->
      asciiIndex = c + 63
      #        console.log "asciiIndex: #{asciiIndex}"
      hashToAdd = String.fromCharCode asciiIndex
      #        console.log "hashToAdd: #{hashToAdd}"
      hash += hashToAdd
    hash

#coord_chunks expected to be an [[]], where index is a coord -> [lat, lon]
#some coordinate offset is represented by 4 to 5 binary chunks
  decode: (hash, isZoomLevel, isSingle) ->
    coord_chunks = [
      []
    ]
    chunkSet = 0
    _(hash).each (char) ->
#      console.log "char: #{char}"
      # convert each character to decimal from ascii
      value = ord(char) - 63
      #      console.log "char code: #{value}"
      # values that have a chunk following have an extra 1 on the left
      split_after = not (value & 0x20)
      value &= mask
      coord_chunks[chunkSet].push value
      if split_after
        chunkSet += 1 #move on to next lat/lon
        coord_chunks.push []
    coord_chunks.pop() #last set is bogus

    #    console.log "COORD CHUNKS: #{coord_chunks}"
    #    coord_chunks.forEach (chunk,key) ->
    #      console.log "coord #{key}: chunk val #{chunk}"
    coords = coord_chunks.map (coord_chunk) ->
      coord = 0
      coord_chunk.forEach (chunk, i) ->
        coord |= chunk << (i * 5)
      #there is a 1 on the right if the coord is negative
      unless isZoomLevel
        coord = decodeCoord coord
      coord
    #    console.log "COORDS: #{coords}"
    if isSingle
      return coords[0]
    coords

  round: (value, precision) ->
    value.toFixed precision

  tuple: (left, right, factory = geohash64.GoogleLatLon) ->
#    console.log "left: #{left}, right:#{right}"
    new factory(left, right)