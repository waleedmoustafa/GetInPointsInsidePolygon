using Points.Api.Services;
using Microsoft.AspNetCore.Mvc;
using Points.Api.Configuration;
using Points.Api.Core;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics.Metrics;
using System.Runtime.InteropServices;
using System.Net;
using Points.Api.DTOs;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Data.Entity;
using System.Reflection.Metadata;
using System.Collections.Generic;
using static Points.Api.Services.LatLngOrderer;

namespace Points.Api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PointsController : BaseApiController
    {
        private readonly ILogger<PointsController> _logger;
        private readonly IPointProvider _provider;
        private readonly AppSettings _appSettings;
        private readonly PointsDbConext _dbcontext;

        public PointsController(ILogger<PointsController> logger, IPointProvider provider, AppSettings appSettings
            , PointsDbConext dbcontext, IJsonFieldsSerializer jsonFieldsSerializer) : base(jsonFieldsSerializer)
        {
            _logger = logger;
            _provider = provider;
            _appSettings = appSettings;
            _dbcontext = dbcontext;
        }

        [HttpPost]
        [Route("/api/GetInPoints", Name = "GetInPoints")]
        [ProducesResponseType(typeof(PointsRootObject), (int)HttpStatusCode.OK)]
        [ProducesResponseType(typeof(void), (int)HttpStatusCode.NoContent)]
        public async Task<IActionResult> GetInPoints([FromBody] List<PointDto> points)
        {
            //reOrder points
            //var orderPoints = PolygonGenerator.OrderCornersClockwise(points);
            List<PolygonEdge> edges = new List<PolygonEdge>();
            int counter = 1;

            PolygonEdge edge;
            foreach (var point in points)
            {
                edge = new PolygonEdge();

                edge.Lat = point.Lat;
                edge.Long = point.Long;
                //edge.EdgeOrder = point.OrderId;
                edge.EdgeOrder = counter++;
                edges.Add(edge);
            }
            var pointsList = await _dbcontext.GetListOfPoints(_dbcontext, edges);

            var pointsRootObject = new PointsRootObject
            {
                Points = pointsList
            };
            var json = JsonFieldsSerializer.Serialize(pointsRootObject, "");

            return Ok(json);
        }


        [HttpPost]
        [Route("/api/SortPoints", Name = "SortPoints")]
        [ProducesResponseType(typeof(LatLngPointsRootObject), (int)HttpStatusCode.OK)]
        [ProducesResponseType(typeof(void), (int)HttpStatusCode.NoContent)]
        public async Task<IActionResult> SortPoints([FromBody] List<LatLngPoint> points)
        {
            //var orderPoints = PolygonGenerator.OrderCornersClockwise(points);
            var orderPoints = LatLngOrderer.OrderPointsClockwise(points);
            var pointsRootObject = new LatLngPointsRootObject
            {
                Points = orderPoints
            };
            var json = JsonFieldsSerializer.Serialize(pointsRootObject, "");

            return Ok(json);
        }
    }
}