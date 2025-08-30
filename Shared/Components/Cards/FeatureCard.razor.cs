// Services/TrainingService.cs
using Microsoft.AspNetCore.Components;

namespace KutechBlazor.Shared.Components.Cards
{
    public partial class FeatureCard
    {
        [Parameter] public string Icon { get; set; } = "";
        [Parameter] public string Title { get; set; } = "";
        [Parameter] public string Description { get; set; } = "";
    }
}