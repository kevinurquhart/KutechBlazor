// Models/BlogPost.cs
using Microsoft.Data.SqlClient;
using System.Data;

namespace KutechBlazor.Models
{
    public class BlogPost
    {
        public int Id { get; set; }
        public string Title { get; set; } = "";
        public string Slug { get; set; } = "";
        public string Content { get; set; } = "";
        public string Summary { get; set; } = "";
        public string Author { get; set; } = "";
        public DateTime PublishedDate { get; set; }
        public string Category { get; set; } = "";
        public string Tags { get; set; } = "";
        public string FeaturedImageUrl { get; set; } = "";
    }
}
