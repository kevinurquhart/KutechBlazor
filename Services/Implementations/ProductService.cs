// Services/ProductService.cs
using System.Data;
using Microsoft.Data.SqlClient;
using Dapper;

public class ProductService : IProductService
{
    private readonly IDbConnection _dbConnection;
    private readonly IConfiguration _configuration;

    public ProductService(IDbConnection dbConnection, IConfiguration configuration)
    {
        _dbConnection = dbConnection;
        _configuration = configuration;
    }

    public async Task<List<Product>> GetFeaturedProductsAsync()
    {
        using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

        // Using stored procedure as per your preference
        var products = await connection.QueryAsync<Product>(
            "sp_GetFeaturedProducts",
            commandType: CommandType.StoredProcedure
        );

        return products.ToList();
    }

    public async Task<List<Product>> GetAllProductsAsync()
    {
        using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

        var products = await connection.QueryAsync<Product>(
            "sp_GetAllProducts",
            commandType: CommandType.StoredProcedure
        );

        return products.ToList();
    }

    public async Task<Product?> GetProductByIdAsync(int id)
    {
        using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

        var product = await connection.QueryFirstOrDefaultAsync<Product>(
            "sp_GetProductById",
            new { ProductId = id },
            commandType: CommandType.StoredProcedure
        );

        return product;
    }

    public async Task<List<Product>> GetProductsByCategoryAsync(string category)
    {
        using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

        var products = await connection.QueryAsync<Product>(
            "sp_GetProductsByCategory",
            new { Category = category },
            commandType: CommandType.StoredProcedure
        );

        return products.ToList();
    }
}

