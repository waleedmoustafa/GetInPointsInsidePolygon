using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Data;

namespace Points.Api.Core
{
    public class PointsDbConext : DbContext
    {
        public PointsDbConext(DbContextOptions<PointsDbConext> options) : base(options)
        {

        }
        public virtual DbSet<Company> company { get; set; }

        public void ExecuteStoredProcedure(DbContext dbContext, List<PolygonEdge> myTable)
        {
            string storedProcedureName = "SP_CheckInOrOut_V4";

            var parameter = new SqlParameter
            {
                ParameterName = "@PolygonEdges",
                SqlDbType = SqlDbType.Structured,
                TypeName = "dbo.PolygonEdge",
                Value = myTable.ToDataTable() // Convert the list to a DataTable
            };

           var res =  dbContext.Database.ExecuteSqlRaw($"EXEC {storedProcedureName} @PolygonEdges", parameter);

        }

        public async Task<IList<Company>> GetListOfPoints (DbContext dbContext, List<PolygonEdge> myTable)
        {
            string storedProcedureName = "SP_GetPointsInPolygon";

            var parameter = new SqlParameter
            {
                ParameterName = "@PolygonEdges",
                SqlDbType = SqlDbType.Structured,
                TypeName = "dbo.PolygonEdge",
                Value = myTable.ToDataTable() // Convert the list to a DataTable
            };

            //var res =  dbContext.Database.ExecuteSqlRaw($"EXEC {storedProcedureName} @PolygonEdges", parameter);

            var sqlQuery = $"EXEC {storedProcedureName} @PolygonEdges";
            var records = dbContext.Set<Company>().FromSqlRaw(sqlQuery, parameter).ToList();
            return records;
        }
    }
}
