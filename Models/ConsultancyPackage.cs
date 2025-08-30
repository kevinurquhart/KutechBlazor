// Models/ConsultancyPackage.cs
using Microsoft.Data.SqlClient;
using System.Data;

public class ConsultancyPackage
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public string Description { get; set; } = "";
    public decimal Price { get; set; }
    public string Duration { get; set; } = "";
    public List<string> Includes { get; set; } = new();
}

