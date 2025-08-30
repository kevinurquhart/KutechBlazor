// Services/IBlogService.cs
using Microsoft.Data.SqlClient;
using System.Data;
using KutechBlazor.Models;

namespace KutechBlazor.Services.Interfaces
{
    public interface IBlogService
    {
        Task<List<BlogPost>> GetRecentPostsAsync(int count);
        Task<BlogPost?> GetPostByIdAsync(int id);
        Task<List<BlogPost>> GetPostsByCategoryAsync(string category);
    }
}
