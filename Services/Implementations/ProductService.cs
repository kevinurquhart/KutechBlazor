// Services/ProductService.cs
using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using KutechBlazor.Services.Interfaces;
using KutechBlazor.Models;

namespace KutechBlazor.Services.Implementations
{
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
                "GetFeaturedProducts",
                commandType: CommandType.StoredProcedure
            );

            return products.ToList();
        }

        public async Task<List<Product>> GetAllProductsAsync()
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var products = await connection.QueryAsync<Product>(
                "GetAllProducts",
                commandType: CommandType.StoredProcedure
            );

            return products.ToList();
        }

        public async Task<Product?> GetProductByIdAsync(int id)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var product = await connection.QueryFirstOrDefaultAsync<Product>(
                "GetProductById",
                new { ProductId = id },
                commandType: CommandType.StoredProcedure
            );

            return product;
        }

        public async Task<List<Product>> GetProductsByCategoryAsync(string category)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var products = await connection.QueryAsync<Product>(
                "GetProductsByCategory",
                new { Category = category },
                commandType: CommandType.StoredProcedure
            );

            return products.ToList();
        }
    }
}
