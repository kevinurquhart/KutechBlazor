// Services/ITrainingService.cs
using Microsoft.Data.SqlClient;
using System.Data;
using KutechBlazor.Models;

namespace KutechBlazor.Services.Interfaces
{
    public interface ITrainingService
    {
        Task<List<Course>> GetOnDemandCoursesAsync();
        Task<List<Course>> GetRemoteCoursesAsync();
        Task<List<Course>> GetInPersonCoursesAsync();
        Task<Course?> GetCourseByIdAsync(int id);
    }
}
