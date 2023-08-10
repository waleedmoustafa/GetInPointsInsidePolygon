using Newtonsoft.Json;
using Points.Api.Core;
using static Points.Api.Services.LatLngOrderer;

namespace Points.Api.DTOs
{
    public class PointsRootObject : ISerializableObject
    {
        public PointsRootObject()
        {
            Points = new List<Company>();
        }

        [JsonProperty("points")]
        public IList<Company> Points { get; set; }

        public string GetPrimaryPropertyName()
        {
            return "points";
        }

        public Type GetPrimaryPropertyType()
        {
            return typeof(Company);
        }
    }

    public class LatLngPointsRootObject : ISerializableObject
    {
        public LatLngPointsRootObject()
        {
            Points = new List<LatLngPoint>();
        }

        [JsonProperty("points")]
        public IList<LatLngPoint> Points { get; set; }

        public string GetPrimaryPropertyName()
        {
            return "points";
        }

        public Type GetPrimaryPropertyType()
        {
            return typeof(LatLngPoint);
        }
    }
}
