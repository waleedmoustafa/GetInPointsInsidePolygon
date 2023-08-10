using System.DirectoryServices.AccountManagement;
using System.Security.Principal;

namespace Points.Api.DTOs
{
    public class PointDto
    {
        public decimal Lat { get; set; }
        public decimal Long { get; set; }
        public int OrderId { get; set; } = 0;
    }
}
