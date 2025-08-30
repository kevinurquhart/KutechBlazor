// Services/TrainingService.cs
using KutechBlazor.Models;
using Microsoft.AspNetCore.Components;

namespace KutechBlazor.Shared.Components.Cards
{
    public partial class ProductCard
    {
        [Parameter] public Product Product { get; set; } = new();

        private void AddToCart(int productId)
        {
            // TODO: Implement cart service
            Navigation.NavigateTo($"/cart/add/{productId}");
        }
    }
}