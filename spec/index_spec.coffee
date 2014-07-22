# encoding: utf-8
###
ported from @a_dat's geohash64Test.py
MIT license.
###
describe 'LatLon', ->
  it 'can be created', ->
    ll = new geohash64.LatLon(35.4, 135.5)
    ll.lat.should.be.eql 35.4
    ll.lon.should.be.eql 135.5

  it 'should throw range error', ->
    new geohash64.LatLon(110, 135).should.throwError
#
#self.assertRaises(
#  geohash64.OutOfRangeError,
#  geohash64.LatLon, 45.1, -190)
#
#def test_encode(self):
#"""LatLon→hash"""
#ll = geohash64.LatLon(35.026131, 135.780673)
#self.assertRaises(
#  geohash64.OutOfRangeError,
#  geohash64.encode, ll, precision=0)
#
#self.assertEqual(
#  geohash64.encode(ll, precision=2),
#  "3g")
#
#self.assertEqual(
#  geohash64.encode(ll, precision=6),
#  "3gLiVI")
#
#self.assertEqual(
#  geohash64.encode(ll, precision=12),
#  "3gLiVIlRVX_O")
#
#def test_decode(self):
#"""hash->LatLon"""
#precise_ll = geohash64.LatLon(35.026131, 135.780673)
#
#ll = geohash64.decode("3g")
#self.assertAlmostEqual(ll.lat, precise_ll.lat, -1)
#self.assertAlmostEqual(ll.lon, precise_ll.lon, -1)
#
#ll = geohash64.decode("3gL")
#self.assertAlmostEqual(ll.lat, precise_ll.lat, 0)
#self.assertAlmostEqual(ll.lon, precise_ll.lon, 0)
#
#ll = geohash64.decode("3gLiVI")
#self.assertAlmostEqual(ll.lat, precise_ll.lat, 2)
#self.assertAlmostEqual(ll.lon, precise_ll.lon, 2)
#
#def test_distance_from(self):
#ll1 = geohash64.LatLon(35.65500, 139.74472)
#ll2 = geohash64.LatLon(33.59532, 130.36208)
#self.assertAlmostEqual(
#  ll1.distance_from(ll2),
#  890233.064304, 5)
#
#self.assertAlmostEqual(
#  ll1.distance_to(ll2),
#  890233.064304, 5)
#
#self.assertRaises(
#  geohash64.InvalidArgumentError,
#  ll1.distance_to, "not LatLon Object")
#
#
#if __name__ == '__main__':
#suite = unittest.makeSuite(geohash64Test)
#  unittest.TextTestRunner(verbosity=2).run(suite)
## unittest.main()