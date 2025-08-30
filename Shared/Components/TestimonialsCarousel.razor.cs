// Services/TrainingService.cs
namespace KutechBlazor.Shared.Components
{
    public partial class TestimonialsCarousel
    {
        private List<Testimonial> testimonials = new();
        private int currentIndex = 0;
        private System.Threading.Timer? autoPlayTimer;

        public class Testimonial
        {
            public string Text { get; set; } = "";
            public string Author { get; set; } = "";
            public string Role { get; set; } = "";
            public int Rating { get; set; } = 5;
        }

        protected override void OnInitialized()
        {
            // Load testimonials - in real app, this would come from a service
            testimonials = new List<Testimonial>
        {
            new Testimonial
            {
                Text = "Text goes here",
                Author = "John Smith",
                Role = "Database Administrator"
            },
            new Testimonial
            {
                Text = "Text goes here",
                Author = "Sarah Johnson",
                Role = "IT Manager"
            },
            new Testimonial
            {
                Text = "Text goes here",
                Author = "Michael Brown",
                Role = "Senior Developer"
            }
        };

            // Start auto-play
            autoPlayTimer = new System.Threading.Timer(_ =>
            {
                InvokeAsync(() =>
                {
                    NextSlide();
                    StateHasChanged();
                });
            }, null, TimeSpan.FromSeconds(5), TimeSpan.FromSeconds(5));
        }

        private void NextSlide()
        {
            currentIndex = (currentIndex + 1) % testimonials.Count;
        }

        private void PrevSlide()
        {
            currentIndex = currentIndex == 0 ? testimonials.Count - 1 : currentIndex - 1;
        }

        private void GoToSlide(int index)
        {
            currentIndex = index;
        }

        public void Dispose()
        {
            autoPlayTimer?.Dispose();
        }
    }
}