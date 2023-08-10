namespace Points.Api.Services
{
    public static class LatLngOrderer
    {
        public static List<LatLngPoint> OrderPointsClockwise(List<LatLngPoint> points)
        {
            // Convert latitude-longitude coordinates to Cartesian coordinates
            List<CartesianPoint> cartesianPoints = points.Select(ConvertToCartesian).ToList();

            // Calculate the centroid of the polygon
            double centroidX = cartesianPoints.Sum(c => c.X) / cartesianPoints.Count;
            double centroidY = cartesianPoints.Sum(c => c.Y) / cartesianPoints.Count;
            double centroidZ = cartesianPoints.Sum(c => c.Z) / cartesianPoints.Count;
            CartesianPoint centroid = new CartesianPoint { X = centroidX, Y = centroidY, Z = centroidZ };

            // Sort the Cartesian points based on the angle relative to the centroid
            List<CartesianPoint> sortedCartesianPoints = cartesianPoints.OrderBy(c => GetAngleRelativeToCentroid(c, centroid)).ToList();

            // Convert the sorted Cartesian points back to latitude-longitude coordinates
            List<LatLngPoint> orderedPoints = sortedCartesianPoints.Select(ConvertToLatLng).ToList();

            return orderedPoints;
        }

        private static CartesianPoint ConvertToCartesian(LatLngPoint point)
        {
            double latitudeRad = DegreesToRadians(point.Lat);
            double longitudeRad = DegreesToRadians(point.Long);

            double x = Math.Cos(latitudeRad) * Math.Cos(longitudeRad);
            double y = Math.Cos(latitudeRad) * Math.Sin(longitudeRad);
            double z = Math.Sin(latitudeRad);

            return new CartesianPoint { X = x, Y = y, Z = z };
        }

        private static LatLngPoint ConvertToLatLng(CartesianPoint point)
        {
            double longitudeRad = RadiansToDegrees(Math.Atan2(point.Y, point.X));
            double latitudeRad = RadiansToDegrees(Math.Asin(point.Z));

            return new LatLngPoint { Lat = latitudeRad, Long= longitudeRad };
        }

        private static double GetAngleRelativeToCentroid(CartesianPoint point, CartesianPoint centroid)
        {
            double dotProduct = (point.X - centroid.X) * (centroid.X) + (point.Y - centroid.Y) * (centroid.Y) + (point.Z - centroid.Z) * (centroid.Z);
            double crossProductMagnitude = Math.Sqrt(Math.Pow(point.Y * centroid.Z - point.Z * centroid.Y, 2) +
                                                     Math.Pow(point.Z * centroid.X - point.X * centroid.Z, 2) +
                                                     Math.Pow(point.X * centroid.Y - point.Y * centroid.X, 2));

            double angleRad = Math.Atan2(crossProductMagnitude, dotProduct);
            return angleRad < 0 ? angleRad + 2 * Math.PI : angleRad;
        }

        private static double DegreesToRadians(double degrees)
        {
            return degrees * Math.PI / 180.0;
        }

        private static double RadiansToDegrees(double radians)
        {
            return radians * 180.0 / Math.PI;
        }

        private class CartesianPoint
        {
            public double X { get; set; }
            public double Y { get; set; }
            public double Z { get; set; }
        }

        public class LatLngPoint
        {
            //public double Latitude { get; set; }
            //public double Longitude { get; set; }

            public double Lat { get; set; }
            public double Long{ get; set; }
        }
    }
}
