// Services/ConsultancyService.cs
using Microsoft.Data.SqlClient;
using System.Data;
using KutechBlazor.Services.Interfaces;
using KutechBlazor.Models;

namespace KutechBlazor.Services.Implementations
{
    public class ConsultancyService : IConsultancyService
    {
        private readonly IConfiguration _configuration;

        public ConsultancyService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<List<ConsultancyPackage>> GetPackagesAsync()
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var packages = await connection.QueryAsync<ConsultancyPackage>(
                "GetConsultancyPackages",
                commandType: CommandType.StoredProcedure
            );

            return packages.ToList();
        }

        public async Task<ConsultancyPackage?> GetPackageByIdAsync(int id)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var package = await connection.QueryFirstOrDefaultAsync<ConsultancyPackage>(
                "GetConsultancyPackageById",
                new { PackageId = id },
                commandType: CommandType.StoredProcedure
            );

            return package;
        }
    }
}