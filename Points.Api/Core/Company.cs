using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Runtime.InteropServices;

namespace Points.Api.Core
{
    public class Company
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Lat { get; set; }
        public decimal Long { get; set; }
    }
}
