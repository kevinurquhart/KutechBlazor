// Services/IConsultancyService.cs
using Microsoft.Data.SqlClient;
using System.Data;

public interface IConsultancyService
{
    Task<List<ConsultancyPackage>> GetPackagesAsync();
    Task<ConsultancyPackage?> GetPackageByIdAsync(int id);
}

