// Services/ITrainingService.cs
using Microsoft.Data.SqlClient;
using System.Data;

public interface ITrainingService
{
    Task<List<Course>> GetOnDemandCoursesAsync();
    Task<List<Course>> GetRemoteCoursesAsync();
    Task<List<Course>> GetInPersonCoursesAsync();
    Task<Course?> GetCourseByIdAsync(int id);
}

