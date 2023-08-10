using Points.Api.DTOs;
using System.Security.Principal;

namespace Points.Api.Services
{
    public interface IPointProvider
    {
        Task<PointDto> GetInnterPoints(List<PointDto> points);
        Task<bool> IsPointIn(List<PointDto> points);
    }
}
