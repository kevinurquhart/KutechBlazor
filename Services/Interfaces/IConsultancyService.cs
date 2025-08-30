// Services/IConsultancyService.cs
using Microsoft.Data.SqlClient;
using System.Data;
using KutechBlazor.Models;

namespace KutechBlazor.Services.Interfaces
{
    public interface IConsultancyService
    {
        Task<List<ConsultancyPackage>> GetPackagesAsync();
        Task<ConsultancyPackage?> GetPackageByIdAsync(int id);
    }
}
