###############################################################################
# LatLon Class
###############################################################################
class LatLon
  constructor: (arg1, arg2) ->
    if Array.isArray arg1
      lat = arg1[0]
      lon = arg1[1]
    else
      lat = arg1
      lon = arg2
    if !arg1?
      throw new Error('One of LatLong arg1')
    if arg2?
      arg2Type = typeof arg2
      arg1Type = typeof arg1
      if arg2Type != arg1Type
        throw new Error("arg1 to arg2 type mismatch: arg1 type: #{arg1Type}, arg2 type: #{arg2Type}")
    if not (-90 <= lat and lat <= 90)
      throw new Error('lat is out of range.')
    if not (-180 <= lon and lon <= 180)
      throw new Error('lon is out of range.')
    @lat = Number(lat)
    @lon = Number(lon)

  toString: =>
    """LatLon unit='degree'
    lat:#{@lat}, lon:#{@lon},
    """

  add: (ll) =>
    new LatLon @lat + ll.lat, @lon + ll.lon

  getGeoHash:(precision=10) =>
    #"""LatLon => GeoHash64"""
    throw new Error('precision is out of range.') unless 0 < precision

    lat = (@lat + 90) / 180  # => 0.69091
    lon = (@lon + 180) / 360  # => 0.22069
#    lat = bigint(@lat.toString(),64).add(90).div(180)  # => 0.69091
#    lon = bigint(@lat.toString(),64).add(180).div(360)  # => 0.22069
    hash = ''

    for i in [0...precision] by 1
      do(i) ->
#        lat = lat.mul(8)
#        lon = lon.mul(8)
#        lat_int = lat.toNumber()
#        lon_int = lon.toNumber()
        lat *= 8
        lon *= 8
        lat_int = float2int(lat)
        lon_int = float2int(lon)
        index = ((lat_int << 3) & 32)
        + ((lon_int << 2) & 16)
        + ((lat_int << 2) & 8)
        + ((lon_int << 1) & 4)
        + ((lat_int << 1) & 2)
        + ((lon_int << 0) & 1)
#        console.log "geohash64: #{codeMap}"
#        console.log "HASH STRING: #{indexStr}"
        hash += indexStr[index]

    return new GeoHash64(hash)

  distance_to:(another_LatLon)=>
    @distance_from(another_LatLon)

  distance_from:(another_LatLon) =>
    ###
    Hubeny's formula
    http://yamadarake.web.fc2.com/trdi/2009/report000001.html
    ###
    if not (another_LatLon?.lat? and another_LatLon?.lon?)
      throw new Error 'Argument is not LatLon'
    lat1_rad = @lat * Math.PI / 180
    lon1_rad = @lon * Math.PI / 180
    lat2_rad = another_LatLon.lat * Math.PI / 180
    lon2_rad = another_LatLon.lon * Math.PI / 180
    lat_average_rad = (lat1_rad + lat2_rad) / 2
    lat_diff = lat1_rad - lat2_rad
    lon_diff = lon1_rad - lon2_rad

    #todo set these magic numbers to variable names
    meridian = (6335439.327 / ((1 - 0.006694379990 * Math.sin(lat_average_rad) ** 2) ** 3) ** 0.5)
    prime_vertical = (6378137.000 / (1 - 0.006694379990 * Math.sin(lat_average_rad) ** 2) ** 0.5)
    return (((meridian * lat_diff) ** 2 + (prime_vertical * Math.cos(lat_average_rad) * lon_diff) ** 2) ** 0.5)
