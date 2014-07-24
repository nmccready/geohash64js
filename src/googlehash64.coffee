###############################################################################
# GoogleHash64 Class
###############################################################################
namespace 'geohash64'
class geohash64.GoogleHash64
  constructor: (hash, precision = 10) ->
    throw new Error 'Argument is invalid' unless _.isString hash
    @hash = hash
    @precision = @hash.length
    @south_west_ll = undefined
    @center_ll = undefined
    @hash2geo()

  toString: =>
    """geohash64.GeoHash64:
            hash: #{@hash},
            center_ll: #{@center_ll},
    """
  hash2geo: =>
    decimal_list = [geohash64.codeMap[s] for s in @hash] # s = "Z"
#    decimal_list = _(@hash).map (s) -> geohash64.codeMap[s] # s = "Z"
    lat = 0.0
    lon = 0.0
    console.log decimal_list
    for decimal in decimal_list by -1
      # decimal = 25 = 0b011001
      console.log "DECIMAL: #{decimal}"
      lat += (decimal >> 3) & 4 # => 0b100
      lon += (decimal >> 2) & 4 # => 0b100
      lat += (decimal >> 2) & 2 # => 0b010
      lon += (decimal >> 1) & 2 # => 0b010
      lat += (decimal >> 1) & 1 # => 0b001
      lon += (decimal >> 0) & 1 # => 0b001
      lat /= 8 # >>=3
      lon /= 8 # >>=3

    @ll = new geohash64.LatLon(lat * 180 - 90, lon * 360 - 180)

    @set_error()
    @south_west_ll = @ll
    @center_ll = @ll.add @error

  set_error: =>
    @error = new geohash64.LatLon 90.0 / 8 ** @precision, 180.0 / 8 ** @precision
    @coordinate_error = new geohash64.Coordinate(
      @ll.distance_to(new geohash64.LatLon(@ll.lat + @error.lat, @ll.lon)),
      @ll.distance_to(new geohash64.LatLon(@ll.lat, @ll.lon + @error.lon))
    )