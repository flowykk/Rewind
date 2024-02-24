using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests;

public class UserRegisterRequest
{
    [Required, MinLength(4)]
    public string UserName { get; set; } = string.Empty;
    
    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;
    
    [Required, MinLength(6)]
    public string Password { get; set; } = string.Empty;
    
}