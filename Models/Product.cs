// Models/Product.cs
using Microsoft.Data.SqlClient;
using System.Data;

public class Product
{
    public int Id { get; set; }
    public string Title { get; set; } = "";
    public string Description { get; set; } = "";
    public string Category { get; set; } = "";
    public decimal Price { get; set; }
    public string Duration { get; set; } = "";
    public string Level { get; set; } = "";
    public bool IsFeatured { get; set; }
    public string ImageUrl { get; set; } = "";
}

