// Services/IProductService.cs
using Microsoft.Data.SqlClient;
using System.Data;

public interface IProductService
{
    Task<List<Product>> GetFeaturedProductsAsync();
    Task<List<Product>> GetAllProductsAsync();
    Task<Product?> GetProductByIdAsync(int id);
    Task<List<Product>> GetProductsByCategoryAsync(string category);
}

