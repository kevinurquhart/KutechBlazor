// Services/TrainingService.cs
using Microsoft.AspNetCore.Components;

namespace KutechBlazor.Shared.Components.Cards
{
    public partial class TrainingCard
    {
        [Parameter] public string Title { get; set; } = "";
        [Parameter] public string Description { get; set; } = "";
        [Parameter] public string Price { get; set; } = "";
        [Parameter] public string Link { get; set; } = "";
        [Parameter] public string Icon { get; set; } = "";
    }
}