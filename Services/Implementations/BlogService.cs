// Services/BlogService.cs
using Microsoft.Data.SqlClient;
using System.Data;

public class BlogService : IBlogService
{
    private readonly IConfiguration _configuration;

    public BlogService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public async Task<List<BlogPost>> GetRecentPostsAsync(int count)
    {
        using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

        var posts = await connection.QueryAsync<BlogPost>(
            "sp_GetRecentBlogPosts",
            new { Count = count },
            commandType: CommandType.StoredProcedure
        );

        return posts.ToList();
    }

    public async Task<BlogPost?> GetPostByIdAsync(int id)
    {
        using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

        var post = await connection.QueryFirstOrDefaultAsync<BlogPost>(
            "sp_GetBlogPostById",
            new { PostId = id },
            commandType: CommandType.StoredProcedure
        );

        return post;
    }

    public async Task<List<BlogPost>> GetPostsByCategoryAsync(string category)
    {
        using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

        var posts = await connection.QueryAsync<BlogPost>(
            "sp_GetBlogPostsByCategory",
            new { Category = category },
            commandType: CommandType.StoredProcedure
        );

        return posts.ToList();
    }
}

