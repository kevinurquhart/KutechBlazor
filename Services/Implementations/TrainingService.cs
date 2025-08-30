// Services/TrainingService.cs
using Microsoft.Data.SqlClient;
using System.Data;
using KutechBlazor.Services.Interfaces;
using KutechBlazor.Models;

namespace KutechBlazor.Services.Implementations
{
    public class TrainingService : ITrainingService
    {
        private readonly IConfiguration _configuration;

        public TrainingService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<List<Course>> GetOnDemandCoursesAsync()
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var courses = await connection.QueryAsync<Course>(
                "GetOnDemandCourses",
                commandType: CommandType.StoredProcedure
            );

            return courses.ToList();
        }

        public async Task<List<Course>> GetRemoteCoursesAsync()
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var courses = await connection.QueryAsync<Course>(
                "GetRemoteCourses",
                commandType: CommandType.StoredProcedure
            );

            return courses.ToList();
        }

        public async Task<List<Course>> GetInPersonCoursesAsync()
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var courses = await connection.QueryAsync<Course>(
                "GetInPersonCourses",
                commandType: CommandType.StoredProcedure
            );

            return courses.ToList();
        }

        public async Task<Course?> GetCourseByIdAsync(int id)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var course = await connection.QueryFirstOrDefaultAsync<Course>(
                "GetCourseById",
                new { CourseId = id },
                commandType: CommandType.StoredProcedure
            );

            return course;
        }
    }
}
