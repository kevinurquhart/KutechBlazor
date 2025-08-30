// Services/IBlogService.cs
using Microsoft.Data.SqlClient;
using System.Data;

public interface IBlogService
{
    Task<List<BlogPost>> GetRecentPostsAsync(int count);
    Task<BlogPost?> GetPostByIdAsync(int id);
    Task<List<BlogPost>> GetPostsByCategoryAsync(string category);
}

