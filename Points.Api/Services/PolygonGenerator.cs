using Points.Api.DTOs;
using System.Drawing;

namespace Points.Api.Services
{
    public static class PolygonGenerator
    {

        public static List<PointDto> OrderCornersClockwise(List<PointDto> corners)
        {
            // Calculate the centroid of the polygon
            double centroidX = corners.Sum(c => (double)c.Lat) / corners.Count;
            double centroidY = corners.Sum(c => (double)c.Long) / corners.Count;
            PointDto centroid = new PointDto {Lat = (decimal)centroidX, Long = (decimal)centroidY };

            // Sort the corners based on the angle relative to the centroid
            List<PointDto> orderedCorners = corners.OrderBy(c => Math.Atan2((double)c.Long - (double)centroid.Long, (double)c.Long - (double)centroid.Long)).ToList();

            return orderedCorners;
        }

    }
}
