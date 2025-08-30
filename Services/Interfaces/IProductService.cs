// Services/IProductService.cs
using Microsoft.Data.SqlClient;
using System.Data;
using KutechBlazor.Models;

namespace KutechBlazor.Services.Interfaces
{
    public interface IProductService
    {
        Task<List<Product>> GetFeaturedProductsAsync();
        Task<List<Product>> GetAllProductsAsync();
        Task<Product?> GetProductByIdAsync(int id);
        Task<List<Product>> GetProductsByCategoryAsync(string category);
    }
}
