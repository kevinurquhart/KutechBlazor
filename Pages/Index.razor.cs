// Services/TrainingService.cs
using KutechBlazor.Models;

namespace KutechBlazor.Pages
{
    public partial class Index
    {
        private List<Product>? featuredProducts;

        protected override async Task OnInitializedAsync()
        {
            // Load featured products from service
            featuredProducts = await ProductService.GetFeaturedProductsAsync();
        }
    }
}