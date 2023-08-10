using System.ComponentModel;
using System.Data;

namespace Points.Api.Core
{
    public class PolygonEdge
    {
        public decimal Lat { get; set; }
        public decimal Long { get; set; }
        public int EdgeOrder { get; set; }
    }
}
