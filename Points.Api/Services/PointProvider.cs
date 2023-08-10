using Points.Api.Middlewares;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Security.Principal;
using System.Text.RegularExpressions;
using Novell.Directory.Ldap;
using System.ComponentModel;
using System.Reflection.Emit;
using Novell.Directory.Ldap.Utilclass;
using Novell.Directory.Ldap.Controls;
using System.Collections;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Collections.Generic;
using System.Xml.Linq;
using System.Net.NetworkInformation;
using System.Numerics;
using Points.Api.DTOs;

namespace Points.Api.Services
{
    public class PointProvider : IPointProvider
    {
        public Task<PointDto> GetInnterPoints(List<PointDto> points)
        {
            PointDto point = new PointDto();

            var inSide1 = IsPointInClockwiseTriangle(points[0], points[1], points[2], points[3]);
            var inSide2 = IsPointInClockwiseTriangle(points[0], points[1], points[3], points[4]);
            if (inSide1 || inSide2)
            {
                point = points[0];
            }


            return Task.FromResult(point);
        }

        public Task<bool> IsPointIn(List<PointDto> points)
        {
            bool res = false;

            var inSide1 = IsPointInClockwiseTriangle(points[0], points[1], points[2], points[3]);
            var inSide2 = IsPointInClockwiseTriangle(points[0], points[1], points[3], points[4]);

            if (inSide1 || inSide2)
            {
                res = true;
            }


            return Task.FromResult(res);
        }

        private bool IsPointInClockwiseTriangle(PointDto p, PointDto p0, PointDto p1, PointDto p2)
        {
            var s = (p0.Long * p2.Lat - p0.Lat * p2.Long + (p2.Long - p0.Long) * p.Lat + (p0.Lat - p2.Lat) * p.Long);
            var t = (p0.Lat * p1.Long - p0.Long * p1.Lat + (p0.Long - p1.Long) * p.Lat + (p1.Lat - p0.Lat) * p.Long);

            if (s <= 0 || t <= 0)
                return false;

            var A = (-p1.Long * p2.Lat + p0.Long * (-p1.Lat + p2.Lat) + p0.Lat * (p1.Long - p2.Long) + p1.Lat * p2.Long);

            return (s + t) < A;
        }
    }
}