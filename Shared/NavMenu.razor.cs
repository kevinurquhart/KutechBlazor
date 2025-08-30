// Services/TrainingService.cs
namespace KutechBlazor.Shared
{
    public partial class NavMenu
    {
        private bool isExpanded = false;
        private string? openDropdown = null;
        private int cartItemCount = 0;

        private string NavMenuCssClass => isExpanded ? "nav-menu expanded" : "nav-menu";

        private void ToggleNavMenu()
        {
            isExpanded = !isExpanded;
        }

        private void ToggleDropdown(string dropdown)
        {
            openDropdown = openDropdown == dropdown ? null : dropdown;
        }

        protected override void OnInitialized()
        {
            // TODO: Load cart count from service
        }
    }
}