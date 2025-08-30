// Models/Course.cs
using Microsoft.Data.SqlClient;
using System.Data;

namespace KutechBlazor.Models
{
    public class Course
    {
        public int Id { get; set; }
        public string Title { get; set; } = "";
        public string Description { get; set; } = "";
        public string Level { get; set; } = "";
        public string Duration { get; set; } = "";
        public decimal Price { get; set; }
        public string DeliveryMethod { get; set; } = "";
        public string Syllabus { get; set; } = "";
        public DateTime? NextDate { get; set; }
    }
}
