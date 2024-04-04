using System.ComponentModel.DataAnnotations;

namespace RewindApp.Domain.Requests;

public class FilterSettings
{
    [Required] public bool Images { get; set; } = true;
    [Required] public bool Quotes { get; set; } = true;
    [Required] public bool OnlyFavorites { get; set; } = false;
}